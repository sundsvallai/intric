# Intric Configuration Guide

## TLDR

- **Required Settings**:
  - Database connection (all POSTGRES\_\* variables)
  - Redis connection (REDIS_HOST, REDIS_PORT)
  - Security settings (all JWT*\*, API*\*, URL_SIGNING_KEY)
  - Upload limits (all UPLOAD\_\*, MAX_IN_QUESTION)
- **LLM Integration**: Configure at least one provider (OpenAI, Anthropic, Azure, OVHCloud, Mistral, VLLM, etc.)
- **Authentication**: Local auth by default, optional MobilityGuard/Zitadel OIDC integration
- **Feature Flags**: Control access management, IAM, image generation, crawling features (all have defaults)

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

| Variable            | Description                                                     | Default   | Required | Example     |
| ------------------- | --------------------------------------------------------------- | --------- | -------- | ----------- |
| `POSTGRES_HOST`     | Database hostname                                               | None      | Yes      | `localhost` |
| `POSTGRES_USER`     | Database username                                               | None      | Yes      | `postgres`  |
| `POSTGRES_PASSWORD` | Database password                                               | None      | Yes      | `postgres`  |
| `POSTGRES_PORT`     | Database port                                                   | None      | Yes      | `5432`      |
| `POSTGRES_DB`       | Database name                                                   | None      | Yes      | `postgres`  |
| `DATABASE_URL`      | Complete database URL (auto-generated from individual settings) | Generated | No       | -           |

### Redis Configuration

Variables for configuring Redis:

| Variable         | Description                                             | Default | Required | Example     |
| ---------------- | ------------------------------------------------------- | ------- | -------- | ----------- |
| `REDIS_HOST`     | Redis hostname                                          | None    | Yes      | `localhost` |
| `REDIS_PORT`     | Redis port                                              | None    | Yes      | `6379`      |
| `REDIS_PASSWORD` | Redis password (if required)                            | None    | No       | -           |
| `REDIS_DB`       | Redis database index                                    | `0`     | No       | `0`         |
| `REDIS_URL`      | Complete Redis URL (alternative to individual settings) | None    | No       | -           |

### Security and Authentication

Variables for configuring security settings:

| Variable              | Description                                  | Default | Required | Example   |
| --------------------- | -------------------------------------------- | ------- | -------- | --------- |
| `JWT_SECRET`          | Secret key for JWT tokens                    | None    | Yes      | `1234`    |
| `JWT_AUDIENCE`        | JWT audience claim                           | None    | Yes      | `*`       |
| `JWT_ISSUER`          | JWT issuer claim                             | None    | Yes      | `EXAMPLE` |
| `JWT_EXPIRY_TIME`     | JWT token expiry time in seconds             | None    | Yes      | `86000`   |
| `JWT_ALGORITHM`       | Algorithm used for JWT                       | None    | Yes      | `HS256`   |
| `JWT_TOKEN_PREFIX`    | Prefix for JWT token in Authorization header | None    | Yes      | (empty)   |
| `API_PREFIX`          | Prefix for API routes                        | None    | Yes      | `/api/v1` |
| `API_KEY_LENGTH`      | Length of API keys                           | None    | Yes      | `64`      |
| `API_KEY_HEADER_NAME` | Header name for API key                      | None    | Yes      | `example` |
| `URL_SIGNING_KEY`     | Key for signing URLs                         | None    | Yes      | (empty)   |

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

| Variable                           | Description                                    | Default | Required | Example           |
| ---------------------------------- | ---------------------------------------------- | ------- | -------- | ----------------- |
| `UPLOAD_FILE_TO_SESSION_MAX_SIZE`  | Maximum file size for session uploads (bytes)  | None    | Yes      | `1048576` (1MB)   |
| `UPLOAD_IMAGE_TO_SESSION_MAX_SIZE` | Maximum image size for session uploads (bytes) | None    | Yes      | `1048576` (1MB)   |
| `UPLOAD_MAX_FILE_SIZE`             | Maximum file size for general uploads (bytes)  | None    | Yes      | `10485760` (10MB) |
| `TRANSCRIPTION_MAX_FILE_SIZE`      | Maximum file size for transcription (bytes)    | None    | Yes      | `10485760` (10MB) |
| `MAX_IN_QUESTION`                  | Maximum files in question                      | None    | Yes      | `1`               |

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

| Variable                       | Description                                      | Default                                               | Required |
| ------------------------------ | ------------------------------------------------ | ----------------------------------------------------- | -------- |
| `INTRIC_BACKEND_URL`           | URL for backend API                              | `https://api.intric.ai`                               | Yes      |
| `INTRIC_BACKEND_SERVER_URL`    | Backend URL for server-side rendering (optional) | None                                                  | No       |
| `JWT_SECRET`                   | JWT secret (legacy - not currently used)         | None                                                  | No       |
| `FEEDBACK_FORM_URL`            | URL for feedback form (deprecated)               | None                                                  | No       |
| `PUBLIC_URL`                   | Public URL for the application                   | None                                                  | No       |
| `MOBILITY_GUARD_AUTH`          | MobilityGuard auth URL                           | None                                                  | No       |
| `SHOW_TEMPLATES`               | Show templates in UI                             | `False`                                               | No       |
| `SHOW_WEB_SEARCH`              | Enable web search feature                        | `False`                                               | No       |
| `SHOW_HELP_CENTER`             | Show help center link                            | `False`                                               | No       |
| `ZITADEL_INSTANCE_URL`         | Zitadel authentication instance URL              | None                                                  | No       |
| `ZITADEL_PROJECT_CLIENT_ID`    | Zitadel project client ID                        | None                                                  | No       |
| `FORCE_LEGACY_AUTH`            | Force use of legacy authentication               | `False`                                               | No       |
| `REQUEST_INTEGRATION_FORM_URL` | URL for integration request form                 | None                                                  | No       |
| `HELP_CENTER_URL`              | URL for help center                              | `https://www.intric.ai/en/external-support-assistant` | No       |
| `SUPPORT_EMAIL`                | Support email address                            | `support@intric.ai`                                   | No       |
| `SALES_EMAIL`                  | Sales email address                              | `sales@intric.ai`                                     | No       |

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

Create a `.env` file in the `frontend/apps/web` directory. Here's a minimal example:

```
# Required
INTRIC_BACKEND_URL=http://localhost:8000

# Optional - only needed if backend is on different URL for SSR
# INTRIC_BACKEND_SERVER_URL=http://localhost:8000

# Legacy - no longer used but may be in old configs
# JWT_SECRET=1234

# Feature flags (all default to false)
# SHOW_TEMPLATES=true
# SHOW_WEB_SEARCH=true
# SHOW_HELP_CENTER=true

# External authentication (if using Zitadel)
# ZITADEL_INSTANCE_URL=https://your-instance.zitadel.cloud
# ZITADEL_PROJECT_CLIENT_ID=your-client-id
```

### Frontend Configuration Notes

The frontend configuration is handled through environment variables at build time. These values are:

- Embedded during the build process for production deployments
- Loaded from `.env` files during local development
- Accessible server-side through SvelteKit's `$env` modules

**Important**: Frontend environment variables are baked into the build and cannot be changed at runtime without rebuilding the application.

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
