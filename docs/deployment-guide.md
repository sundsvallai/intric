# Intric Deployment Guide

## TLDR

- **Requirements**: Docker 20.10+, Docker Compose 2+, PostgreSQL 13+ with pgvector, Redis 6+
- **Components to Deploy**: Frontend (SvelteKit), Backend API (FastAPI), Worker (ARQ), PostgreSQL, Redis
- **Production Stack**: HAProxy (optional load balancer), FastAPI with Gunicorn/Uvicorn, SvelteKit Node.js server (no separate web server required)
- **Recommended Setup**: 4GB+ RAM, 50GB+ storage for production

This guide provides comprehensive instructions for deploying Intric in production environments, with specific guidance for HAProxy and RHEL8 deployments.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Development Setup](#development-setup)
- [Production Deployment](#production-deployment)
- [HAProxy Configuration](#haproxy-configuration)
- [RHEL8 Specific Setup](#rhel8-specific-setup)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)

## Architecture Overview

Production deployment typically consists of:

1. **Load Balancer** (HAProxy - optional, used in environments like Sundsvall municipality)
2. **Backend Services** (FastAPI with Gunicorn/Uvicorn workers)
3. **Frontend Service** (SvelteKit Node.js server)
4. **Background Workers** (ARQ workers)
5. **Database** (PostgreSQL with pgvector)
6. **Cache/Queue** (Redis)

## Prerequisites

### System Requirements

- **OS**: Linux (RHEL8, Ubuntu 20.04+, or similar)
- **Docker**: 20.10+ and Docker Compose 2+ (or Podman for RHEL8)
- **RAM**: Minimum 4GB, recommended 8GB+
- **Storage**: Minimum 50GB for production
- **CPU**: 2+ cores recommended

### Software Dependencies

- PostgreSQL 13+ with pgvector extension
- Redis 6+
- Python 3.11+ (for backend)
- Node.js 18+ and pnpm (for frontend)
- HAProxy (optional, for load balancing in production environments)

## Development Setup

For local development, use the provided docker-compose:

```bash
cd backend
docker compose up -d  # Starts PostgreSQL and Redis

# Backend setup
poetry install
poetry run python init_db.py  # Initialize database
poetry run start  # Start API server on port 8000

# Worker setup (in another terminal)
poetry run arq src.intric.worker.arq.WorkerSettings

# Frontend setup (in another terminal)
cd ../frontend
pnpm install
pnpm run setup
pnpm -w run dev  # Start dev server on port 5173
```

## Production Deployment

### 1. Environment Configuration

Create environment files for both backend and frontend:

**Backend (.env)**:

```bash
# Database
POSTGRES_USER=intric
POSTGRES_PASSWORD=<secure-password>
POSTGRES_HOST=<database-host>
POSTGRES_PORT=5432
POSTGRES_DB=intric

# Redis
REDIS_HOST=<redis-host>
REDIS_PORT=6379

# Security
JWT_SECRET=<secure-random-string>
JWT_AUDIENCE=intric
JWT_ISSUER=intric
API_KEY_HEADER_NAME=X-API-Key

# LLM Providers (at least one required)
OPENAI_API_KEY=<your-key>
# ANTHROPIC_API_KEY=<your-key>

# Feature Flags
USING_ACCESS_MANAGEMENT=True

# Logging
LOGLEVEL=INFO
```

**Frontend (.env)**:

```bash
INTRIC_BACKEND_URL=https://api.yourdomain.com
JWT_SECRET=<same-as-backend>
PUBLIC_URL=https://yourdomain.com
```

### 2. Database Setup

Install PostgreSQL with pgvector:

```bash
# RHEL8
sudo dnf install postgresql13-server postgresql13-contrib
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl enable postgresql-13
sudo systemctl start postgresql-13

# Install pgvector
sudo dnf install postgresql13-devel
git clone https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install

# Create database and enable extension
sudo -u postgres psql
CREATE DATABASE intric;
\c intric
CREATE EXTENSION vector;
```

### 3. Redis Setup

```bash
# RHEL8
sudo dnf install redis
sudo systemctl enable redis
sudo systemctl start redis
```

### 4. Backend Deployment

Build and deploy the backend:

```bash
# Build Docker image
cd backend
docker build -t intric-backend:latest .

# Or deploy directly with systemd
# Create systemd service file: /etc/systemd/system/intric-backend.service
[Unit]
Description=Intric Backend API
After=network.target postgresql-13.service redis.service

[Service]
Type=exec
User=intric
WorkingDirectory=/opt/intric/backend
Environment="PATH=/opt/intric/backend/.venv/bin:/usr/local/bin:/usr/bin"
ExecStart=/opt/intric/backend/.venv/bin/gunicorn src.intric.server.main:app \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --access-logfile - \
  --error-logfile -
Restart=always

[Install]
WantedBy=multi-user.target
```

### 5. Worker Deployment

Deploy ARQ workers:

```bash
# Create systemd service file: /etc/systemd/system/intric-worker.service
[Unit]
Description=Intric Background Worker
After=network.target postgresql-13.service redis.service

[Service]
Type=exec
User=intric
WorkingDirectory=/opt/intric/backend
Environment="PATH=/opt/intric/backend/.venv/bin:/usr/local/bin:/usr/bin"
ExecStart=/opt/intric/backend/.venv/bin/arq src.intric.worker.arq.WorkerSettings
Restart=always

[Install]
WantedBy=multi-user.target
```

### 6. Frontend Deployment

Build and deploy the frontend:

```bash
cd frontend
pnpm install
pnpm run setup
pnpm run build

# The SvelteKit Node.js server serves the built application directly
# No separate web server is required
```

### 7. Service Configuration

**Backend Service (FastAPI with Gunicorn)**:
The backend runs directly with Gunicorn and Uvicorn workers on port 8000.

**Frontend Service (SvelteKit Node.js)**:
The frontend runs as a Node.js server on port 3000, serving the built SvelteKit application.

Example systemd service file `/etc/systemd/system/intric-frontend.service`:

```ini
[Unit]
Description=Intric Frontend Service
After=network.target

[Service]
Type=exec
User=intric
WorkingDirectory=/opt/intric/frontend/apps/web
Environment="NODE_ENV=production"
ExecStart=/usr/bin/node build/index.js
Restart=always

[Install]
WantedBy=multi-user.target
```

**Direct Access**:

- Backend API: `http://server:8000`
- Frontend: `http://server:3000`

**Note**: Unlike traditional setups, Intric doesn't require a separate web server like Nginx. The SvelteKit Node.js server handles static file serving and the FastAPI server handles API requests directly.

## HAProxy Configuration

For production deployments at scale, HAProxy provides load balancing:

```haproxy
global
    maxconn 4096
    log /dev/log local0
    chroot /var/lib/haproxy
    user haproxy
    group haproxy
    daemon

defaults
    mode http
    log global
    option httplog
    option dontlognull
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend web_frontend
    bind *:80
    bind *:443 ssl crt /etc/haproxy/certs/intric.pem
    redirect scheme https if !{ ssl_fc }

    # ACLs
    acl is_api path_beg /api
    acl is_websocket hdr(Upgrade) -i WebSocket

    # Backend selection
    use_backend api_backend if is_api
    use_backend ws_backend if is_websocket
    default_backend web_backend

backend web_backend
    balance roundrobin
    server frontend1 10.0.0.10:3000 check
    server frontend2 10.0.0.11:3000 check

backend api_backend
    balance roundrobin
    server api1 10.0.0.20:8000 check
    server api2 10.0.0.21:8000 check
    server api3 10.0.0.22:8000 check

backend ws_backend
    balance source
    server api1 10.0.0.20:8000 check
    server api2 10.0.0.21:8000 check
    server api3 10.0.0.22:8000 check
```

## RHEL8 Specific Setup

### SELinux Configuration

Configure SELinux for Intric:

```bash
# Allow httpd to connect to network
sudo setsebool -P httpd_can_network_connect 1

# Allow httpd to connect to Redis
sudo setsebool -P httpd_can_network_connect_db 1

# Create custom policy if needed
sudo ausearch -c 'python' --raw | audit2allow -M intric-python
sudo semodule -i intric-python.pp
```

### Firewall Configuration

```bash
# Open required ports
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-port=8000/tcp  # Backend API
sudo firewall-cmd --permanent --add-port=3000/tcp  # Frontend SvelteKit server
sudo firewall-cmd --reload
```

### Podman Alternative to Docker

RHEL8 uses Podman by default:

```bash
# Build with Podman
podman build -t intric-backend:latest ./backend

# Run with Podman
podman run -d --name intric-backend \
  --env-file .env \
  -p 8000:8000 \
  intric-backend:latest

# Generate systemd service from container
podman generate systemd --name intric-backend > /etc/systemd/system/intric-backend.service
```

## Maintenance

### Database Backups

Set up automated PostgreSQL backups:

```bash
# Create backup script: /opt/intric/scripts/backup.sh
#!/bin/bash
BACKUP_DIR="/var/backups/intric"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DATABASE="intric"

mkdir -p $BACKUP_DIR
pg_dump -U postgres -d $DATABASE | gzip > $BACKUP_DIR/intric_$TIMESTAMP.sql.gz

# Keep only last 7 days
find $BACKUP_DIR -name "intric_*.sql.gz" -mtime +7 -delete
```

Add to crontab:

```bash
0 2 * * * /opt/intric/scripts/backup.sh
```

### Monitoring

Monitor key metrics:

- API response times
- Worker queue depth
- Database connections
- Memory and CPU usage

### Updates

To update Intric:

1. Backup database
2. Update code:
   ```bash
   cd /opt/intric
   git pull origin main
   ```
3. Update dependencies:
   ```bash
   cd backend
   poetry install
   poetry run alembic upgrade head
   ```
4. Rebuild frontend:
   ```bash
   cd ../frontend
   pnpm install
   pnpm run build
   ```
5. Restart services:
   ```bash
   sudo systemctl restart intric-backend intric-worker intric-frontend
   ```

## Troubleshooting

### Common Issues

1. **Database Connection Issues**

   - Check PostgreSQL is running: `systemctl status postgresql-13`
   - Verify pgvector extension: `psql -d intric -c "SELECT * FROM pg_extension WHERE extname = 'vector';"`
   - Check connection settings in .env

2. **Worker Not Processing Jobs**

   - Check Redis connectivity: `redis-cli ping`
   - Check worker logs: `journalctl -u intric-worker -f`
   - Verify ARQ queue: `redis-cli KEYS arq:*`

3. **WebSocket Connection Failures**

   - Check HAProxy WebSocket backend configuration (if using HAProxy)
   - Verify firewall allows WebSocket connections
   - Ensure backend WebSocket endpoints are accessible

4. **High Memory Usage**
   - Adjust worker count in Gunicorn
   - Configure PostgreSQL connection pooling
   - Monitor vector index size and optimize as needed

### Log Locations

- Backend API: `/var/log/intric/api.log` or `journalctl -u intric-backend`
- Worker: `/var/log/intric/worker.log` or `journalctl -u intric-worker`
- Frontend: `journalctl -u intric-frontend`
- HAProxy: `/var/log/haproxy.log` (if using HAProxy)
- PostgreSQL: `/var/lib/pgsql/13/data/log/`

### Performance Tuning

1. **PostgreSQL Optimization**

   ```sql
   -- Optimize for vector searches
   SET maintenance_work_mem = '1GB';
   SET max_parallel_maintenance_workers = 4;

   -- Create indexes
   CREATE INDEX ON info_blob_chunks USING ivfflat (embedding vector_cosine_ops);
   ```

2. **API Performance**

   - Increase Gunicorn workers based on CPU cores
   - Enable response caching where appropriate
   - Use connection pooling for database

3. **Frontend Performance**
   - Configure response compression in SvelteKit
   - Set proper cache headers for static assets
   - Use CDN for static file delivery
   - Optimize SvelteKit build settings
