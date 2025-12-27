# PostgreSQL 17 with pgvector, PostGIS, and pg_trgm

A Docker image featuring PostgreSQL 17 with three powerful extensions pre-installed and automatically enabled:

- **pgvector** - Vector similarity search for AI/ML applications
- - **PostGIS** - Geospatial data support
  - - **pg_trgm** - Full-text search trigram matching
   
    - This image is automatically built and pushed to GitHub Container Registry (GHCR) whenever changes are made to the Dockerfile or workflow.
   
    - ## Features
   
    - - **PostgreSQL 17** - Latest stable version
      - - **pgvector 0.7.4** - High-performance vector similarity search
        - - **PostGIS 3** - Advanced geographic information system
          - - **pg_trgm** - Trigram-based text search
            - - **Automatic Extension Initialization** - All extensions are created automatically on database initialization
              - - **Multi-arch Support** - Built with Docker Buildx
               
                - ## Quick Start
               
                - ### Pull the Image
               
                - ```bash
                  docker pull ghcr.io/ukalpa/postgresql-docker-ghcr:latest
                  ```

                  ### Run the Container

                  ```bash
                  docker run -d \
                    --name postgres-custom \
                    -e POSTGRES_PASSWORD=your_password \
                    -e POSTGRES_DB=mydb \
                    -p 5432:5432 \
                    ghcr.io/ukalpa/postgresql-docker-ghcr:latest
                  ```

                  ### Verify Extensions

                  Connect to the database and verify the extensions are enabled:

                  ```bash
                  docker exec -it postgres-custom psql -U postgres -d mydb -c "\\dx"
                  ```

                  You should see:
                  - vector
                  - - pg_trgm
                    - - postgis
                     
                      - ## Usage Examples
                     
                      - ### Using pgvector
                     
                      - ```sql
                        CREATE TABLE embeddings (
                            id SERIAL PRIMARY KEY,
                            embedding vector(1536)
                        );

                        CREATE INDEX ON embeddings USING ivfflat (embedding vector_cosine_ops);

                        INSERT INTO embeddings (embedding) VALUES ('[0.1, 0.2, 0.3, ...]');
                        ```

                        ### Using PostGIS

                        ```sql
                        CREATE TABLE locations (
                            id SERIAL PRIMARY KEY,
                            geom GEOMETRY(Point, 4326)
                        );

                        INSERT INTO locations (geom) VALUES (ST_MakePoint(40.7128, -74.0060));
                        ```

                        ### Using pg_trgm

                        ```sql
                        CREATE INDEX ON documents USING gin (content gin_trgm_ops);

                        SELECT * FROM documents WHERE content % 'search_term';
                        ```

                        ## Image Tags

                        - `latest` - Latest build from main branch
                        - - `<branch-name>` - Builds from specific branches
                          - - `sha-<commit-hash>` - Builds from specific commits
                           
                            - ## Build and Push with GitHub Actions
                           
                            - The image is automatically built and pushed to GHCR using GitHub Actions when:
                            - 1. Changes are pushed to the `main` branch
                              2. 2. The `Dockerfile` or workflow file is modified
                                 3. 3. A workflow is manually triggered
                                   
                                    4. The workflow:
                                    5. - Uses Docker Buildx for multi-architecture builds
                                       - - Caches layers using GitHub Actions cache
                                         - - Automatically tags images with branch names, commit SHAs, and version tags
                                           - - Pushes to `ghcr.io/ukalpa/postgresql-docker-ghcr`
                                            
                                             - ## Environment Variables
                                            
                                             - Standard PostgreSQL environment variables:
                                             - - `POSTGRES_USER` - Database user (default: postgres)
                                               - - `POSTGRES_PASSWORD` - Database password (required)
                                                 - - `POSTGRES_DB` - Initial database name (default: postgres)
                                                   - - `POSTGRES_INITDB_ARGS` - Additional initdb arguments
                                                    
                                                     - ## Volume Mounts
                                                    
                                                     - ```bash
                                                       docker run -v postgres_data:/var/lib/postgresql/data \
                                                         ghcr.io/ukalpa/postgresql-docker-ghcr:latest
                                                       ```

                                                       ## Network

                                                       ```bash
                                                       docker network create postgres_network
                                                       docker run --network postgres_network --name postgres \
                                                         ghcr.io/ukalpa/postgresql-docker-ghcr:latest
                                                       ```

                                                       ## Docker Compose Example

                                                       ```yaml
                                                       version: '3.8'

                                                       services:
                                                         postgres:
                                                           image: ghcr.io/ukalpa/postgresql-docker-ghcr:latest
                                                           environment:
                                                             POSTGRES_PASSWORD: example_password
                                                             POSTGRES_DB: myapp_db
                                                           ports:
                                                             - "5432:5432"
                                                           volumes:
                                                             - postgres_data:/var/lib/postgresql/data
                                                           healthcheck:
                                                             test: ["CMD-SHELL", "pg_isready -U postgres"]
                                                             interval: 10s
                                                             timeout: 5s
                                                             retries: 5

                                                       volumes:
                                                         postgres_data:
                                                       ```

                                                       ## Railway Deployment

                                                       To use this image on Railway:

                                                       1. In Railway, select "Database" > "PostgreSQL"
                                                       2. 2. In the PostgreSQL service settings, under "Image", enter:
                                                          3.    ```
                                                                   ghcr.io/ukalpa/postgresql-docker-ghcr:latest
                                                                   ```
                                                                3. Configure your database environment variables as needed
                                                                4. 4. Deploy and connect to your application
                                                                  
                                                                   5. ## Performance Tuning
                                                                  
                                                                   6. For pgvector with large datasets:
                                                                  
                                                                   7. ```sql
                                                                      -- Use IVFFlat index for faster approximate search
                                                                      CREATE INDEX ON embeddings USING ivfflat (embedding vector_cosine_ops)
                                                                      WITH (lists = 100);

                                                                      -- Or use HNSW for better quality/speed tradeoff
                                                                      CREATE INDEX ON embeddings USING hnsw (embedding vector_cosine_ops)
                                                                      WITH (m = 16, ef_construction = 64);
                                                                      ```

                                                                      ## Security Considerations

                                                                      - Always use strong passwords in production
                                                                      - - Use environment files instead of passing passwords in command line
                                                                        - - Enable SSL/TLS connections
                                                                          - - Use secrets management for sensitive data
                                                                            - - Regularly backup your data
                                                                             
                                                                              - ## Troubleshooting
                                                                             
                                                                              - ### Extensions not loading
                                                                             
                                                                              - Check the initialization logs:
                                                                              - ```bash
                                                                                docker logs postgres-custom
                                                                                ```

                                                                                ### Connection issues

                                                                                Verify the container is running:
                                                                                ```bash
                                                                                docker ps | grep postgresql-docker-ghcr
                                                                                ```

                                                                                Check network connectivity:
                                                                                ```bash
                                                                                docker network inspect postgres_network
                                                                                ```

                                                                                ## Contributing

                                                                                To modify this Docker image:

                                                                                1. Fork the repository
                                                                                2. 2. Update the `Dockerfile`
                                                                                   3. 3. Test locally: `docker build -t test-postgres .`
                                                                                      4. 4. Push to your fork
                                                                                         5. 5. Create a pull request
                                                                                           
                                                                                            6. ## License
                                                                                           
                                                                                            7. This Docker image is based on the official PostgreSQL image and includes pgvector, PostGIS, and pg_trgm extensions.
                                                                                           
                                                                                            8. ## Links
                                                                                           
                                                                                            9. - [PostgreSQL Documentation](https://www.postgresql.org/docs/)
                                                                                               - - [pgvector GitHub](https://github.com/pgvector/pgvector)
                                                                                                 - - [PostGIS Documentation](https://postgis.net/)
                                                                                                   - - [pg_trgm Documentation](https://www.postgresql.org/docs/current/pgtrgm.html)
                                                                                                     - - [GitHub Container Registry Docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
