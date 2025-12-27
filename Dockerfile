# PostgreSQL with pgvector, postgis, and pg_trgm extensions

# Based on official PostgreSQL image




FROM postgres:17




# Install build dependencies, PostGIS, and fix SSL certificates

RUN apt-get update && \

apt-get install -y --no-install-recommends \

ca-certificates \

postgresql-17-postgis-3 \

postgresql-17-postgis-3-scripts \

build-essential \

git \

wget \

postgresql-server-dev-17 \

&& update-ca-certificates \

&& rm -rf /var/lib/apt/lists/*




# Install pgvector extension from release tarball (more reliable than git)

RUN cd /tmp && \

wget https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.4.tar.gz && \

tar -xzf v0.7.4.tar.gz && \

cd pgvector-0.7.4 && \

make && \

make install && \

cd / && \

rm -rf /tmp/pgvector-0.7.4 /tmp/v0.7.4.tar.gz




# pg_trgm is already included in PostgreSQL core




# Optional: Create init script to auto-enable extensions

RUN echo "#!/bin/bash" > /docker-entrypoint-initdb.d/init-extensions.sh && \

echo "set -e" >> /docker-entrypoint-initdb.d/init-extensions.sh && \

echo 'psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL' >> /docker-entrypoint-initdb.d/init-extensions.sh && \

echo '    CREATE EXTENSION IF NOT EXISTS vector;' >> /docker-entrypoint-initdb.d/init-extensions.sh && \

echo '    CREATE EXTENSION IF NOT EXISTS pg_trgm;' >> /docker-entrypoint-initdb.d/init-extensions.sh && \

echo '    CREATE EXTENSION IF NOT EXISTS postgis;' >> /docker-entrypoint-initdb.d/init-extensions.sh && \

echo 'EOSQL' >> /docker-entrypoint-initdb.d/init-extensions.sh && \

chmod +x /docker-entrypoint-initdb.d/init-extensions.sh




LABEL maintainer="HiWars Project"

LABEL description="PostgreSQL 17 with pgvector, postgis, and pg_trgm extensions"
