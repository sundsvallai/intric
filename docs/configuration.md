# Intric Configuration Guide

## TLDR

- **Required Settings**: Database connection (POSTGRES*\*), Redis connection (REDIS*\*), JWT_SECRET
- **LLM Integration**: Configure at least one provider (OpenAI, Anthropic, Azure, OVHCloud, Mistral, VLLM, etc.)
- **Authentication**: Local auth by default, optional MobilityGuard/Zitadel OIDC integration
- **Feature Flags**: Control access management, IAM, image generation, crawling features
- **Upload Limits**: Configure file size limits for uploads and transcriptions

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

| Variable   | Description                                           | Default | Required |
| ---------- | ----------------------------------------------------- | ------- | -------- |
| `LOGLEVEL` | Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL) | `INFO`  | No       |
| `DEV`      | Development mode flag                                 | `False` | No       |
| `TESTING`  | Testing mode flag                                     | `False` | No       |

### Database Configuration

Variables for configuring PostgreSQL database connection:

| Variable            | Description                                                     | Default    | Required |
| ------------------- | --------------------------------------------------------------- | ---------- | -------- |
| `POSTGRES_HOST`     | Database hostname                                               | `db`       | No       |
| `POSTGRES_USER`     | Database username                                               | `postgres` | No       |
| `POSTGRES_PASSWORD` | Database password                                               | None       | Yes      |
| `POSTGRES_PORT`     | Database port                                                   | `5432`     | No       |
| `POSTGRES_DB`       | Database name                                                   | `postgres` | No       |
| `DATABASE_URL`      | Complete database URL (auto-generated from individual settings) | Generated  | No       |

### Redis Configuration

Variables for configuring Redis:

| Variable         | Description                                             | Default | Required |
| ---------------- | ------------------------------------------------------- | ------- | -------- |
| `REDIS_HOST`     | Redis hostname                                          | `redis` | No       |
| `REDIS_PORT`     | Redis port                                              | `6379`  | No       |
| `REDIS_PASSWORD` | Redis password (if required)                            | None    | No       |
| `REDIS_DB`       | Redis database index                                    | `0`     | No       |
| `REDIS_URL`      | Complete Redis URL (alternative to individual settings) | None    | No       |

### Security and Authentication

Variables for configuring security settings:

| Variable              | Description                                  | Default   | Required |
| --------------------- | -------------------------------------------- | --------- | -------- |
| `JWT_SECRET`          | Secret key for JWT tokens                    | None      | Yes      |
| `JWT_AUDIENCE`        | JWT audience claim                           | `*`       | No       |
| `JWT_ISSUER`          | JWT issuer claim                             | `EXAMPLE` | No       |
| `JWT_EXPIRY_TIME`     | JWT token expiry time in seconds             | `86000`   | No       |
| `JWT_ALGORITHM`       | Algorithm used for JWT                       | `HS256`   | No       |
| `JWT_TOKEN_PREFIX`    | Prefix for JWT token in Authorization header | (empty)   | No       |
| `API_PREFIX`          | Prefix for API routes                        | `/api/v1` | No       |
| `API_KEY_LENGTH`      | Length of API keys                           | `64`      | No       |
| `API_KEY_HEADER_NAME` | Header name for API key                      | `example` | No       |

### LLM Integration

Variables for configuring LLM providers:

| Variable                 | Description                         | Default | Required |
| ------------------------ | ----------------------------------- | ------- | -------- |
| `OPENAI_API_KEY`         | OpenAI API key                      | None    | No\*     |
| `ANTHROPIC_API_KEY`      | Anthropic API key                   | None    | No\*     |
| `AZURE_API_KEY`          | Azure API key                       | None    | No\*     |
| `AZURE_MODEL_DEPLOYMENT` | Azure model deployment name         | None    | No       |
| `AZURE_ENDPOINT`         | Azure API endpoint                  | None    | No       |
| `AZURE_API_VERSION`      | Azure API version                   | None    | No       |
| `OVHCLOUD_API_KEY`       | OVHCloud API key                    | None    | No\*     |
| `MISTRAL_API_KEY`        | Mistral API key                     | None    | No\*     |
| `FLUX_API_KEY`           | Flux API key (for image generation) | None    | No       |
| `TAVILY_API_KEY`         | Tavily API key (for web search)     | None    | No       |
| `VLLM_API_KEY`           | VLLM API key                        | None    | No\*     |
| `VLLM_MODEL_URL`         | VLLM model endpoint URL             | None    | No       |
| `INFINITY_URL`           | Infinity embedding service URL      | None    | No       |

\*At least one LLM provider API key is recommended for full functionality.

### File Upload Limits

Variables for configuring file upload limitations:

| Variable                           | Description                            | Default    | Required |
| ---------------------------------- | -------------------------------------- | ---------- | -------- |
| `UPLOAD_FILE_TO_SESSION_MAX_SIZE`  | Maximum file size for session uploads  | `1048576`  | No       |
| `UPLOAD_IMAGE_TO_SESSION_MAX_SIZE` | Maximum image size for session uploads | `1048576`  | No       |
| `UPLOAD_MAX_FILE_SIZE`             | Maximum file size for general uploads  | `10485760` | No       |
| `TRANSCRIPTION_MAX_FILE_SIZE`      | Maximum file size for transcription    | `10485760` | No       |
| `MAX_IN_QUESTION`                  | Maximum files in question              | `1`        | No       |

### Feature Flags

Variables for enabling/disabling features:

| Variable                  | Description                      | Default | Required |
| ------------------------- | -------------------------------- | ------- | -------- |
| `USING_ACCESS_MANAGEMENT` | Enable/disable access management | `True`  | No       |
| `USING_AZURE_MODELS`      | Enable/disable Azure models      | `False` | No       |
| `USING_IAM`               | Enable/disable IAM integration   | `False` | No       |
| `USING_IMAGE_GENERATION`  | Enable/disable image generation  | `False` | No       |
| `USING_CRAWL`             | Enable/disable web crawling      | `True`  | No       |

### MobilityGuard Authentication (Optional)

Variables for MobilityGuard OIDC integration:

| Variable                           | Description                         | Default | Required |
| ---------------------------------- | ----------------------------------- | ------- | -------- |
| `MOBILITYGUARD_DISCOVERY_ENDPOINT` | MobilityGuard discovery endpoint    | None    | No       |
| `MOBILITYGUARD_CLIENT_ID`          | MobilityGuard client ID             | None    | No       |
| `MOBILITYGUARD_CLIENT_SECRET`      | MobilityGuard client secret         | None    | No       |
| `MOBILITY_GUARD_AUTH`              | MobilityGuard auth URL for frontend | None    | No       |

### Web Crawling Configuration

Variables for configuring the web crawler:

| Variable                | Description                       | Default           | Required |
| ----------------------- | --------------------------------- | ----------------- | -------- |
| `CRAWL_MAX_LENGTH`      | Maximum crawl duration in seconds | `14400` (4 hours) | No       |
| `CLOSESPIDER_ITEMCOUNT` | Maximum items to crawl            | `20000`           | No       |
| `OBEY_ROBOTS`           | Respect robots.txt                | `True`            | No       |
| `AUTOTHROTTLE_ENABLED`  | Enable auto-throttling            | `True`            | No       |

### OAuth Integration Configuration

Variables for configuring OAuth integrations:

| Variable                   | Description                    | Default | Required |
| -------------------------- | ------------------------------ | ------- | -------- |
| `OAUTH_CALLBACK_URL`       | OAuth callback URL             | None    | No       |
| `CONFLUENCE_CLIENT_ID`     | Confluence OAuth client ID     | None    | No       |
| `CONFLUENCE_CLIENT_SECRET` | Confluence OAuth client secret | None    | No       |
| `SHAREPOINT_CLIENT_ID`     | SharePoint OAuth client ID     | None    | No       |
| `SHAREPOINT_CLIENT_SECRET` | SharePoint OAuth client secret | None    | No       |

### Internal API Keys

Variables for internal service authentication:

| Variable                     | Description               | Default | Required |
| ---------------------------- | ------------------------- | ------- | -------- |
| `INTRIC_MARKETPLACE_API_KEY` | Marketplace API key       | None    | No       |
| `INTRIC_MARKETPLACE_URL`     | Marketplace URL           | None    | No       |
| `INTRIC_SUPER_API_KEY`       | Super admin API key       | None    | No       |
| `INTRIC_SUPER_DUPER_API_KEY` | Super duper admin API key | None    | No       |
| `URL_SIGNING_KEY`            | Key for signing URLs      | None    | No       |

### Frontend Specific Settings

Variables specifically for the frontend:

| Variable              | Description                     | Default                 | Required |
| --------------------- | ------------------------------- | ----------------------- | -------- |
| `INTRIC_BACKEND_URL`  | URL for backend API             | `http://localhost:8123` | Yes      |
| `JWT_SECRET`          | JWT secret (must match backend) | None                    | Yes      |
| `FEEDBACK_FORM_URL`   | URL for feedback form           | None                    | No       |
| `PUBLIC_URL`          | Public URL for the application  | None                    | No       |
| `MOBILITY_GUARD_AUTH` | MobilityGuard auth URL          | None                    | No       |
| `SHOW_TEMPLATES`      | Show templates in UI            | `True`                  | No       |

## Docker Configuration

### Development Docker Compose

The project includes a `docker-compose.yml` for local development with PostgreSQL (with pgvector) and Redis:

```yaml
services:
  db:
    image: pgvector/pgvector:pg13
    environment:
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### Production Deployment

For production, you'll need to:

1. Set up PostgreSQL with pgvector extension
2. Set up Redis for caching and task queue
3. Deploy backend API service(s)
4. Deploy worker service(s)
5. Deploy frontend service
6. Configure reverse proxy (e.g., HAProxy) - optional for load balancing

Note: Production docker-compose files should be created based on your specific infrastructure requirements.

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
    backendUrl: "https://api.example.com",
    features: {
      showTemplates: true,
    },
  };
</script>
```

## Backend Configuration

### Application Settings

The backend uses Pydantic settings management with automatic environment variable loading. Settings are defined in `backend/src/intric/main/config.py`:

- Settings are loaded from environment variables
- `.env` file is supported for local development
- All settings use lowercase with underscores (e.g., `postgres_host`)
- Environment variables should use uppercase (e.g., `POSTGRES_HOST`)

### Database URLs

The system automatically generates database URLs from individual settings:

- `database_url`: Async connection string for SQLAlchemy (postgresql+asyncpg)
- `sync_database_url`: Sync connection string for migrations (postgresql)

### CORS Configuration

CORS is configured in the FastAPI application setup. To customize CORS settings, modify the middleware configuration in the application initialization.

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

### Production Best Practices

1. **Environment Variables**

   - Use a secrets management system for sensitive values
   - Never commit `.env` files with production secrets
   - Use different JWT secrets for different environments

2. **Database Configuration**

   - Use connection pooling (configured by default in SQLAlchemy)
   - Consider read replicas for high-traffic deployments
   - Ensure pgvector indexes are properly configured for performance

3. **Redis Configuration**

   - Use Redis persistence for production
   - Configure appropriate memory limits
   - Consider Redis Sentinel or Cluster for high availability

4. **Worker Configuration**

   - Scale workers based on workload
   - Monitor queue depth and processing times
   - Configure appropriate task timeouts

5. **Reverse Proxy Setup (HAProxy) - Optional**
   - Configure SSL/TLS termination
   - Set up proper health checks
   - Load balancing across multiple instances
   - Configure request/response timeouts
   - Enable gzip compression
   - Set security headers

### Monitoring and Observability

Consider setting up:

- Application metrics (via Prometheus/Grafana)
- Log aggregation (via ELK stack or similar)
- Error tracking (via Sentry or similar)
- Performance monitoring

### Configuration Validation

The backend validates all required configuration on startup. If any required configuration is missing, the application will fail to start with a clear error message indicating which variables are missing.
