# Intric Deployment Guide

## TLDR
- **Requirements**: Docker Engine 20.10+, Docker Compose 2+, 4GB RAM (recommended)
- **Quick Deploy**:
  1. Create `.env` file with required variables
  2. Pull images: `docker-compose pull`
  3. Start services: `docker-compose up -d`
  4. Initialize database: `docker-compose --profile init up db-init` (first time only)
  5. Verify with: `docker-compose ps`
- **Production Setup**: Configure SSL/TLS, persistent volumes, regular backups, and resource limits

This guide provides comprehensive instructions for deploying Intric in a production environment.

## Table of Contents
- [Prerequisites](#prerequisites)
- [System Requirements](#system-requirements)
- [Version Compatibility](#version-compatibility)
- [Configuration](#configuration)
- [Deployment Steps](#deployment-steps)
- [Using Nexus Registry](#using-nexus-registry)
- [Production Considerations](#production-considerations)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)
- [Web Server Configuration](#web-server-configuration)

## Prerequisites

- Linux server with Docker Engine 20.10.x or later
- Docker Compose 2.x or later
- At least 4GB RAM (recommended), 1GB RAM (minimum)
- Sufficient disk space for database storage (consider the 25x multiplier for vector embeddings)
- At least 2GB of disk space for Docker images
- Outbound internet connectivity to LLM APIs (not necessary for on-prem deployments)
- Access to a Docker registry containing Intric images

## System Requirements

Since Intric uses pgvector for vector embeddings, its memory requirements are optimized:

- **Recommended**: 4GB RAM
- **Minimum**: 1GB RAM

**Storage considerations**: 
- Vector embeddings require approximately 25x the size of the original text data
- Docker images: Frontend (~150MB) and Backend (~800MB) require approximately 1GB
- Additional storage for Docker volumes: Allow at least 10GB of free space for database growth
- Current cloud deployment uses approximately 50GB of storage

## Version Compatibility

For production deployments, maintain version consistency between components:

| Component | Compatible Versions |
|-----------|-------------------|
| Frontend  | Must match Backend major.minor version |
| Backend   | Must match Frontend major.minor version |
| Worker    | Must be identical to Backend version |
| PostgreSQL | 13.x with pgvector |
| Redis     | 6.x or later |

When upgrading, always update the frontend and backend to matching versions.

## Configuration

### Environment Variables

The entire Intric platform is configured through environment variables in a `.env` file. The docker-compose.yml file uses the pattern `${VARIABLE_NAME:-default_value}` which means:
- If defined in .env, that value will be used
- If not defined, the default value in docker-compose.yml will be used
- You don't need to modify docker-compose.yml directly

Here's a comprehensive list of available environment variables:

#### Network Configuration
- `SERVICE_FQDN_FRONTEND`: Frontend domain name
- `FRONTEND_PORT`: Port for the frontend service (default: 3000)
- `BACKEND_PORT`: Port for the backend service (default: 8123)
- `NEXUS_REGISTRY`: URL of your Docker registry
- `IMAGE_TAG`: Version tag of the images to deploy

#### Database Configuration
- `POSTGRES_HOST`: Database hostname (internal service name: db)
- `POSTGRES_USER`: Database username (default: postgres)
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_PORT`: Database port (default: 5432)
- `POSTGRES_DB`: Database name (default: postgres)

#### Redis Configuration
- `REDIS_HOST`: Redis hostname (internal service name: redis)
- `REDIS_PORT`: Redis port (default: 6379)

#### Security and Authentication
- `JWT_SECRET`: Secret key for JWT tokens
- `JWT_AUDIENCE`: JWT audience claim (default: *)
- `JWT_ISSUER`: JWT issuer claim (default: EXAMPLE)
- `JWT_EXPIRY_TIME`: JWT token expiry time in seconds (default: 86000)
- `JWT_ALGORITHM`: Algorithm used for JWT (default: HS256)
- `JWT_TOKEN_PREFIX`: Prefix for JWT token in Authorization header
- `API_PREFIX`: Prefix for API routes (default: /api/v1)
- `API_KEY_LENGTH`: Length of API keys (default: 64)
- `API_KEY_HEADER_NAME`: Header name for API key (default: example)

#### LLM API Configuration
- `OPENAI_API_KEY`: OpenAI API key
- `ANTHROPIC_API_KEY`: Anthropic API key
- `AZURE_API_KEY`: Azure API key
- `AZURE_MODEL_DEPLOYMENT`: Azure model deployment name
- `AZURE_ENDPOINT`: Azure API endpoint
- `AZURE_API_VERSION`: Azure API version

#### File Upload Limits
- `UPLOAD_FILE_TO_SESSION_MAX_SIZE`: Maximum file size for session uploads (default: 1048576 bytes)
- `UPLOAD_IMAGE_TO_SESSION_MAX_SIZE`: Maximum image size for session uploads (default: 1048576 bytes)
- `UPLOAD_MAX_FILE_SIZE`: Maximum file size for general uploads (default: 10485760 bytes)
- `TRANSCRIPTION_MAX_FILE_SIZE`: Maximum file size for transcription (default: 10485760 bytes)
- `MAX_IN_QUESTION`: Maximum files in question (default: 1)

#### Feature Flags
- `USING_ACCESS_MANAGEMENT`: Enable/disable access management (default: False)
- `USING_AZURE_MODELS`: Enable/disable Azure models (default: False)

#### MobilityGuard Authentication (Optional)
- `MOBILITYGUARD_DISCOVERY_ENDPOINT`: MobilityGuard discovery endpoint
- `MOBILITYGUARD_CLIENT_ID`: MobilityGuard client ID
- `MOBILITYGUARD_CLIENT_SECRET`: MobilityGuard client secret
- `MOBILITY_GUARD_AUTH`: MobilityGuard auth URL for frontend

#### Frontend Specific Settings
- `SHOW_TEMPLATES`: Enable/disable templates display
- `FEEDBACK_FORM_URL`: URL for feedback form

#### Logging
- `LOGLEVEL`: Log level (DEBUG, INFO, WARNING, ERROR) (default: INFO)

## Deployment Steps

1. **Create a `.env` file**:
   ```bash
   cp .env.example .env
   nano .env  # Edit with your specific values
   ```
   
   Ensure you set at least these required variables:
   ```
   NEXUS_REGISTRY=your.nexus.registry.com
   IMAGE_TAG=version_to_deploy
   POSTGRES_PASSWORD=secure_password
   JWT_SECRET=secure_random_string
   ```

2. **Pull the Docker images from your Nexus registry**:
   ```bash
   docker-compose pull
   ```

3. **Start the services**:
   ```bash
   docker-compose up -d
   ```
   This will start all container services defined in docker-compose.yml: frontend, backend, worker, db, and redis.

4. **Initialize the database** (first time only):
   ```bash
   docker-compose --profile init up db-init
   ```
   This command runs the database initialization container which sets up the schema and initial data.

5. **Verify deployment**:
   ```bash
   docker-compose ps
   ```
   Ensure all services are running properly and check logs if needed:
   ```bash
   docker-compose logs -f [service_name]
   ```

6. **Verify connectivity**:
   ```bash
   # Check if the frontend is accessible
   curl http://localhost:${FRONTEND_PORT}
   
   # Check if the backend is responding
   curl -I http://localhost:${BACKEND_PORT}
   ```

## Using Nexus Registry

Intric is designed to use a private Docker registry like Nexus for storing and distributing container images.

### Setting Up Nexus Authentication

1. **Log in to your Nexus registry**:
   ```bash
   docker login ${NEXUS_REGISTRY} -u $NEXUS_USERNAME -p $NEXUS_PASSWORD
   ```

2. **Configure credentials in CI/CD environment**:
   For automated builds, set up authentication in your CI/CD pipeline:
   ```bash
   echo $NEXUS_PASSWORD | docker login ${NEXUS_REGISTRY} -u $NEXUS_USERNAME --password-stdin
   ```

### Building Docker Images for Nexus

1. **Set up environment variables**:
   ```bash
   export NEXUS_REGISTRY="your.nexus.registry.com"
   export IMAGE_TAG="latest"  # or a specific version like "1.0.0"
   ```

2. **Build the backend image**:
   ```bash
   cd backend
   docker build -t ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG} .
   ```

   The backend Dockerfile uses a multi-stage build process:
   - First stage installs build dependencies and Poetry
   - Second stage includes only runtime dependencies for a smaller image
   - Application code is copied into the container
   - The image exposes port 8123 and runs the FastAPI application with uvicorn

3. **Build the frontend image**:
   ```bash
   cd frontend
   docker build -t ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG} .
   ```

   The frontend Dockerfile also uses multi-stage builds:
   - Dependencies are installed using pnpm
   - UI packages are built first
   - Web application is built with proper environment settings
   - Final image is based on Nginx Alpine for serving static content
   - The image exposes port 3000 and runs Nginx with a custom configuration

4. **Push the images to your Nexus registry**:
   ```bash
   docker push ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG}
   docker push ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG}
   ```

### CI/CD Integration

For automated builds, integrate these steps into a CI/CD pipeline:

1. **Build and tag** the images with proper versions:
   ```bash
   # Use Git commit hash or CI build number for versioning
   export IMAGE_TAG=$(git rev-parse --short HEAD)
   
   # Build images
   docker build -t ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG} ./backend
   docker build -t ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG} ./frontend
   
   # Also tag as latest
   docker tag ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG} ${NEXUS_REGISTRY}/intric/backend:latest
   docker tag ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG} ${NEXUS_REGISTRY}/intric/frontend:latest
   ```

2. **Push all images**:
   ```bash
   docker push ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG}
   docker push ${NEXUS_REGISTRY}/intric/backend:latest
   docker push ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG}
   docker push ${NEXUS_REGISTRY}/intric/frontend:latest
   ```

## Production Considerations

1. **SSL/TLS Termination**: For production deployments, set up a reverse proxy (like Nginx or Traefik) for SSL/TLS termination.

2. **Data Persistence**: The Docker Compose configuration creates named volumes for database and Redis data. For production, consider mapping these volumes to specific host directories for easier backup management:
   ```yaml
   volumes:
     postgres_data:
       driver: local
       driver_opts:
         type: none
         device: /path/to/persistent/storage/postgres
         o: bind
     redis_data:
       driver: local
       driver_opts:
         type: none
         device: /path/to/persistent/storage/redis
         o: bind
     backend_data:
       driver: local
       driver_opts:
         type: none
         device: /path/to/persistent/storage/backend
         o: bind
   ```

3. **Backup Strategy**: Implement regular database backups:
   ```bash
   docker-compose exec db pg_dump -U postgres -d postgres > intric_backup_$(date +%Y%m%d).sql
   ```

4. **Monitoring**: Set up health checks and monitoring for the containers.

5. **Resource Limits**: Define CPU and memory limits for production stability:
   ```yaml
   services:
     backend:
       deploy:
         resources:
           limits:
             cpus: '2'
             memory: 2G
     frontend:
       deploy:
         resources:
           limits:
             cpus: '0.5'
             memory: 512M
   ```

6. **Service Restart Policies**: All services are configured with `restart: unless-stopped` to automatically recover from failures.

7. **Database Admin Access**: Consider setting up a database admin tool like pgAdmin for managing the database. This can be run as an additional container or installed separately.

8. **Firewall Configuration**: Ensure your firewall allows traffic to the required ports (typically 3000 for frontend and 8123 for backend).

## Maintenance

### Updating to a New Version
1. Update the `IMAGE_TAG` in your `.env` file
2. Pull the new images:
   ```bash
   docker-compose pull
   ```
3. Restart the services:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

### Health Checks (Recommended for Production)
Add health checks for all services to ensure they're running properly:

```yaml
services:
  backend:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8123/health"]
      interval: 30s
      timeout: 10s
      retries: 3
  
  frontend:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3
      
  db:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
      
  redis:
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
```

> **Note**: The health endpoints like `/health` don't automatically exist in the codebase. You'll need to implement a health check endpoint in your backend service (typically returning a 200 OK status when the service is healthy) and in your frontend (typically a small static file or simple route that returns a 200 status). These health checks help Docker Compose determine if services are healthy and allow for proper dependency chaining using `depends_on` with the `condition: service_healthy` option.

### Scaling
For higher loads, consider:
- Scaling the worker service with multiple replicas
- Separate database server with optimized configuration
- Load balancing multiple frontend instances

## Troubleshooting

### Common Issues

1. **Database Connection Failures**:
   - Check `POSTGRES_PASSWORD` is correctly set
   - Verify database service is healthy: `docker-compose ps db`
   - Check logs: `docker-compose logs db`

2. **Frontend Can't Reach Backend**:
   - Verify network connectivity between containers
   - Check `INTRIC_BACKEND_URL` is set correctly
   - Check logs: `docker-compose logs frontend`

3. **Authentication Issues**:
   - Ensure `JWT_SECRET` is consistent across services
   - Check MobilityGuard settings if using OIDC

4. **Worker Not Processing Tasks**:
   - Check Redis connection: `docker-compose exec redis redis-cli ping`
   - Verify worker logs: `docker-compose logs worker`

5. **Registry Authentication Issues**:
   - Check if you can log in to your registry: `docker login ${NEXUS_REGISTRY}`
   - Verify your credentials are correctly set in your CI/CD pipeline

6. **File Processing Issues**:
   - Check file size limits in environment variables
   - Verify worker logs for specific error messages
   - Ensure sufficient disk space is available

### Log Analysis

When troubleshooting, check logs for specific services:

```bash
# View logs for a specific service
docker-compose logs -f backend

# View logs for multiple services
docker-compose logs -f backend worker

# View recent logs with limited output
docker-compose logs --tail=100 backend
```

Look for ERROR or WARNING level messages that might indicate configuration or connection issues.

## Web Server Configuration

### Nginx (Default)

The default deployment uses Nginx to serve the frontend static files. The Dockerfile includes an Nginx configuration that:
- Serves the built SvelteKit application 
- Handles compression
- Manages routing for SPA functionality
- Listens on port 3000 (configurable)

### Alternative Web Servers

While Nginx is included in the default configuration, you can replace it with other web servers according to your organization's needs and expertise:

1. **Apache HTTPd**:
   - Popular alternative with strong security features
   - Requires a custom Dockerfile replacing Nginx with Apache

2. **Caddy**:
   - Modern web server with automatic HTTPS
   - Simpler configuration than Nginx or Apache

3. **Traefik**:
   - Modern proxy with automatic service discovery
   - Excellent for microservices architectures
   - Can handle both routing and SSL/TLS termination

To implement an alternative web server, create a custom frontend Dockerfile that uses your preferred server instead of Nginx, and ensure it correctly serves the SvelteKit static files with proper routing configuration.