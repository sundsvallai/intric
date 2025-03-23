# Intric Configuration Guide

## TLDR
- **Required Settings**: NEXUS_REGISTRY, IMAGE_TAG, POSTGRES_PASSWORD, JWT_SECRET
- **LLM Integration**: Configure at least one provider (OpenAI, Anthropic, or Azure)
- **Network Settings**: Configure ports and domain names for production
- **Security Options**: Authentication method, token expiry, and API access control
- **Resource Limits**: Adjust container resources based on expected load

This guide provides comprehensive information about configuring the Intric platform through environment variables and configuration files.

## Table of Contents
- [Configuration Overview](#configuration-overview)
- [Environment Variables](#environment-variables)
- [Docker Configuration](#docker-configuration)
- [Frontend Configuration](#frontend-configuration)
- [Backend Configuration](#backend-configuration)
- [LLM Provider Configuration](#llm-provider-configuration)
- [Database Configuration](#database-configuration)
- [Security Configuration](#security-configuration)
- [Advanced Configuration](#advanced-configuration)

## Configuration Overview

Intric uses a configuration approach based primarily on environment variables. There are several ways to provide these variables:

1. **.env files** - For local development and container deployments
2. **Docker Compose environment** - For production deployments
3. **Environment variables** - Set directly in the host environment

The platform follows the principle that sensible defaults are provided when possible, and configuration can be overridden when needed.

## Environment Variables

### Core Environment Variables

These variables control fundamental aspects of the Intric platform:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `NEXUS_REGISTRY` | URL of Docker registry | None | Yes |
| `IMAGE_TAG` | Version tag for Docker images | `latest` | Yes |
| `FRONTEND_PORT` | Port for frontend service | `3000` | No |
| `BACKEND_PORT` | Port for backend service | `8123` | No |
| `SERVICE_FQDN_FRONTEND` | Frontend domain name | None | Yes (Prod) |
| `LOGLEVEL` | Logging level (DEBUG, INFO, WARNING, ERROR) | `INFO` | No |

### Database Configuration

Variables for configuring PostgreSQL database connection:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `POSTGRES_HOST` | Database hostname | `db` | No |
| `POSTGRES_USER` | Database username | `postgres` | No |
| `POSTGRES_PASSWORD` | Database password | None | Yes |
| `POSTGRES_PORT` | Database port | `5432` | No |
| `POSTGRES_DB` | Database name | `postgres` | No |
| `DATABASE_URL` | Complete database URL (alternative to individual settings) | None | No |

### Redis Configuration

Variables for configuring Redis:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `REDIS_HOST` | Redis hostname | `redis` | No |
| `REDIS_PORT` | Redis port | `6379` | No |
| `REDIS_PASSWORD` | Redis password (if required) | None | No |
| `REDIS_DB` | Redis database index | `0` | No |
| `REDIS_URL` | Complete Redis URL (alternative to individual settings) | None | No |

### Security and Authentication

Variables for configuring security settings:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `JWT_SECRET` | Secret key for JWT tokens | None | Yes |
| `JWT_AUDIENCE` | JWT audience claim | `*` | No |
| `JWT_ISSUER` | JWT issuer claim | `EXAMPLE` | No |
| `JWT_EXPIRY_TIME` | JWT token expiry time in seconds | `86000` | No |
| `JWT_ALGORITHM` | Algorithm used for JWT | `HS256` | No |
| `JWT_TOKEN_PREFIX` | Prefix for JWT token in Authorization header | `Bearer` | No |
| `API_PREFIX` | Prefix for API routes | `/api/v1` | No |
| `API_KEY_LENGTH` | Length of API keys | `64` | No |
| `API_KEY_HEADER_NAME` | Header name for API key | `X-API-Key` | No |

### LLM Integration

Variables for configuring LLM providers:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `OPENAI_API_KEY` | OpenAI API key | None | No* |
| `ANTHROPIC_API_KEY` | Anthropic API key | None | No* |
| `AZURE_API_KEY` | Azure API key | None | No* |
| `AZURE_MODEL_DEPLOYMENT` | Azure model deployment name | None | No |
| `AZURE_ENDPOINT` | Azure API endpoint | None | No |
| `AZURE_API_VERSION` | Azure API version | None | No |

*At least one LLM provider API key is required.

### File Upload Limits

Variables for configuring file upload limitations:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `UPLOAD_FILE_TO_SESSION_MAX_SIZE` | Maximum file size for session uploads | `1048576` | No |
| `UPLOAD_IMAGE_TO_SESSION_MAX_SIZE` | Maximum image size for session uploads | `1048576` | No |
| `UPLOAD_MAX_FILE_SIZE` | Maximum file size for general uploads | `10485760` | No |
| `TRANSCRIPTION_MAX_FILE_SIZE` | Maximum file size for transcription | `10485760` | No |
| `MAX_IN_QUESTION` | Maximum files in question | `1` | No |

### Feature Flags

Variables for enabling/disabling features:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `USING_ACCESS_MANAGEMENT` | Enable/disable access management | `False` | No |
| `USING_AZURE_MODELS` | Enable/disable Azure models | `False` | No |
| `SHOW_TEMPLATES` | Enable/disable templates display | `True` | No |

### MobilityGuard Authentication (Optional)

Variables for MobilityGuard OIDC integration:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `MOBILITYGUARD_DISCOVERY_ENDPOINT` | MobilityGuard discovery endpoint | None | No |
| `MOBILITYGUARD_CLIENT_ID` | MobilityGuard client ID | None | No |
| `MOBILITYGUARD_CLIENT_SECRET` | MobilityGuard client secret | None | No |
| `MOBILITY_GUARD_AUTH` | MobilityGuard auth URL for frontend | None | No |

### Frontend Specific Settings

Variables specifically for the frontend:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `INTRIC_BACKEND_URL` | URL for backend API | `http://localhost:8123` | No |
| `FEEDBACK_FORM_URL` | URL for feedback form | None | No |
| `PUBLIC_URL` | Public URL for the application | None | No |

## Docker Configuration

### Docker Compose Override

For advanced Docker configurations, you can create a `docker-compose.override.yml` file:

```yaml
version: '3.8'

services:
  frontend:
    environment:
      - CUSTOM_VARIABLE=value
    volumes:
      - ./custom-config:/app/config
      
  backend:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
```

### Volume Configuration

For production deployments, configure persistent volumes:

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
```

## Frontend Configuration

### Environment Variables

Create a `.env` file in the frontend directory with these settings:

```
INTRIC_BACKEND_URL=http://localhost:8123
PUBLIC_URL=http://localhost:3000
FEEDBACK_FORM_URL=https://example.com/feedback
```

### Runtime Configuration

The frontend can be configured at runtime through the `window.__RUNTIME_CONFIG__` object:

```html
<script>
  window.__RUNTIME_CONFIG__ = {
    backendUrl: 'https://api.example.com',
    features: {
      showTemplates: true
    }
  };
</script>
```

## Backend Configuration

### Application Settings

The backend application settings can be customized in `backend/app/core/config.py`:

```python
# Example of extending settings
class Settings(BaseSettings):
    # Standard settings here
    
    # Custom settings
    custom_setting: str = "default_value"
    feature_enabled: bool = False
```

### CORS Configuration

Configure Cross-Origin Resource Sharing (CORS) settings:

```
CORS_ORIGINS=http://localhost:3000,https://example.com
CORS_METHODS=GET,POST,PUT,DELETE
CORS_HEADERS=Content-Type,Authorization
```

## LLM Provider Configuration

### OpenAI Configuration

To use OpenAI models:

```
OPENAI_API_KEY=your_api_key
```

### Anthropic Configuration

To use Anthropic Claude models:

```
ANTHROPIC_API_KEY=your_api_key
```

### Azure OpenAI Configuration

To use Azure OpenAI:

```
USING_AZURE_MODELS=True
AZURE_API_KEY=your_api_key
AZURE_MODEL_DEPLOYMENT=your_deployment_name
AZURE_ENDPOINT=https://your-resource-name.openai.azure.com
AZURE_API_VERSION=2023-05-15
```

## Database Configuration

### PostgreSQL Configuration

For production deployments, you may want to fine-tune PostgreSQL performance (recommended):

```
POSTGRES_MAX_CONNECTIONS=100
POSTGRES_SHARED_BUFFERS=1GB
POSTGRES_EFFECTIVE_CACHE_SIZE=3GB
POSTGRES_WORK_MEM=64MB
```

These are standard PostgreSQL configuration parameters that can be passed to the database container.

## Security Configuration

### SSL/TLS Configuration

For production environments, configure SSL/TLS termination through a reverse proxy (recommended):

```
SSL_CERT_PATH=/path/to/cert.pem
SSL_KEY_PATH=/path/to/key.pem
USE_HTTPS=True
```

## Advanced Configuration

### Resource Limits (Docker)

For production deployments, it's recommended to set resource limits for containers to ensure stability and prevent resource starvation:

```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 1G
          
  frontend:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.1'
          memory: 128M
          
  worker:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '0.5'
          memory: 1G
          
  db:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '0.5'
          memory: 1G
```

The `limits` set the maximum resources a container can use, while `reservations` guarantee a minimum amount of resources. Adjust these values based on your workload and available resources.

For additional configuration options, check the source code or contact the development team.