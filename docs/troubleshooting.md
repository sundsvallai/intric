# Intric Troubleshooting Guide

## TLDR

- **Check Logs**: Use `docker compose logs <service_name>` or `journalctl -u <service_name>` for systemd services
- **Verify Configuration**: Ensure environment variables are set correctly in `.env` files
- **Database Issues**: Check PostgreSQL with pgvector is running and accessible
- **Network Problems**: Verify services can communicate, check ports 8000 (backend) and 3000 (frontend)
- **Common Fixes**: Most issues stem from missing dependencies, incorrect config, or port conflicts

This guide provides solutions for common issues encountered when deploying, developing, or using the Intric platform.

## Table of Contents

- [Development Environment Issues](#development-environment-issues)
- [Production Deployment Issues](#production-deployment-issues)
- [Database Issues](#database-issues)
- [Authentication Issues](#authentication-issues)
- [LLM Integration Issues](#llm-integration-issues)
- [Frontend Issues](#frontend-issues)
- [Backend Issues](#backend-issues)
- [Worker Issues](#worker-issues)
- [Performance Issues](#performance-issues)
- [Common Error Messages](#common-error-messages)
- [Getting Help](#getting-help)

## Development Environment Issues

### Initial Setup Problems

**Symptoms:**

- Poetry install fails
- pnpm install fails
- Services won't start

**Solutions:**

1. Verify Python version (3.11+):

   ```bash
   python --version
   ```

2. Verify Node.js version (18+) and pnpm:

   ```bash
   node --version
   pnpm --version
   ```

3. Ensure Docker services are running:

   ```bash
   cd backend
   docker compose up -d
   docker compose ps
   ```

4. Check if ports are already in use:
   ```bash
   lsof -i :8000  # Backend
   lsof -i :3000  # Frontend
   lsof -i :5432  # PostgreSQL
   lsof -i :6379  # Redis
   ```

### Missing Environment Variables

**Symptoms:**

- "Missing required configuration" errors
- Services fail to start

**Solutions:**

1. Create environment files from templates:

   ```bash
   # Backend
   cp backend/.env.template backend/.env

   # Frontend
   cp frontend/apps/web/.env.example frontend/apps/web/.env
   ```

2. Edit `.env` files and set required values:
   - Backend: `JWT_SECRET`, `POSTGRES_PASSWORD`, LLM API keys
   - Frontend: `JWT_SECRET` (must match backend), `INTRIC_BACKEND_URL`

### Database Initialization Fails

**Symptoms:**

- "Relation does not exist" errors
- Cannot login with default credentials

**Solutions:**

1. Ensure PostgreSQL is running:

   ```bash
   docker compose ps db
   ```

2. Run database initialization:

   ```bash
   cd backend
   poetry run python init_db.py
   ```

3. Check migrations are up to date:
   ```bash
   poetry run alembic upgrade head
   ```

## Production Deployment Issues

### Systemd Service Failures

**Symptoms:**

- Services fail to start
- Services restart repeatedly

**Solutions:**

1. Check service status and logs:

   ```bash
   sudo systemctl status intric-backend
   sudo journalctl -u intric-backend -f
   ```

2. Verify working directory and paths in service file:

   ```bash
   sudo cat /etc/systemd/system/intric-backend.service
   ```

3. Ensure virtual environment exists:
   ```bash
   ls -la /opt/intric/backend/.venv
   ```

### HAProxy Configuration Issues

**Symptoms:**

- 502 Bad Gateway errors
- Cannot reach frontend or backend
- WebSocket connections fail

**Solutions:**

1. Verify backend is running on correct port (8000):

   ```bash
   curl http://localhost:8000/api/v1/health
   ```

2. Verify frontend is running on correct port (3000):

   ```bash
   curl http://localhost:3000
   ```

3. Check HAProxy configuration:

   ```bash
   sudo haproxy -c -f /etc/haproxy/haproxy.cfg
   ```

4. Ensure WebSocket support in HAProxy:
   - Check WebSocket backend configuration
   - Verify upgrade headers are handled correctly

### RHEL8/SELinux Issues

**Symptoms:**

- Permission denied errors
- Services can't connect to each other

**Solutions:**

1. Check SELinux status:

   ```bash
   getenforce
   ```

2. Allow httpd network connections:

   ```bash
   sudo setsebool -P httpd_can_network_connect 1
   sudo setsebool -P httpd_can_network_connect_db 1
   ```

3. Create custom SELinux policy if needed:
   ```bash
   sudo ausearch -c 'python' --raw | audit2allow -M intric-python
   sudo semodule -i intric-python.pp
   ```

## Database Issues

### PostgreSQL Connection Failures

**Symptoms:**

- "Could not connect to database" errors
- psycopg2.OperationalError

**Solutions:**

1. Verify PostgreSQL is running:

   ```bash
   sudo systemctl status postgresql-13  # RHEL8
   docker compose ps db                 # Development
   ```

2. Check connection parameters in `.env`:

   ```
   POSTGRES_HOST=localhost  # or actual hostname
   POSTGRES_PORT=5432
   POSTGRES_USER=intric
   POSTGRES_PASSWORD=<your-password>
   POSTGRES_DB=intric
   ```

3. Test connection manually:
   ```bash
   psql -h localhost -p 5432 -U intric -d intric
   ```

### pgvector Extension Issues

**Symptoms:**

- Vector operations fail
- "type vector does not exist" errors

**Solutions:**

1. Verify pgvector is installed:

   ```sql
   \dx vector
   ```

2. Create extension if missing:

   ```sql
   CREATE EXTENSION IF NOT EXISTS vector;
   ```

3. Check vector column exists:
   ```sql
   \d info_blob_chunks
   ```

### Migration Problems

**Symptoms:**

- Database schema out of sync
- "Column does not exist" errors

**Solutions:**

1. Check current migration status:

   ```bash
   cd backend
   poetry run alembic current
   ```

2. Apply pending migrations:

   ```bash
   poetry run alembic upgrade head
   ```

3. If migrations are stuck:
   ```bash
   poetry run alembic stamp head  # Mark as current
   poetry run alembic upgrade head # Apply any new ones
   ```

## Authentication Issues

### JWT Token Problems

**Symptoms:**

- "Invalid token" errors
- 401 Unauthorized responses
- Users logged out unexpectedly

**Solutions:**

1. Verify JWT_SECRET matches between frontend and backend:

   ```bash
   # Backend .env
   grep JWT_SECRET backend/.env

   # Frontend .env
   grep JWT_SECRET frontend/apps/web/.env
   ```

2. Check token in browser DevTools:

   - Network tab → Request headers → Authorization
   - Should be: `Bearer <token>`

3. Decode token to check expiry:
   ```bash
   # Use jwt.io or similar tool
   ```

### Login Failures

**Symptoms:**

- Cannot login with credentials
- "Invalid credentials" error

**Solutions:**

1. For development, use default credentials:

   - Email: `user@example.com`
   - Password: `Password1!`

2. Verify user exists in database:

   ```sql
   SELECT email, username FROM users WHERE email = 'user@example.com';
   ```

3. Check password hashing:
   ```bash
   # Backend logs should show bcrypt operations
   docker compose logs backend | grep -i auth
   ```

### API Key Authentication Issues

**Symptoms:**

- API key not working
- "Invalid API key" errors

**Solutions:**

1. Check API key header name in config:

   ```bash
   grep API_KEY_HEADER_NAME backend/.env
   # Default is "example", production should be "X-API-Key"
   ```

2. Verify API key format in request:
   ```bash
   curl -H "X-API-Key: your-api-key" http://localhost:8000/api/v1/endpoint
   ```

## LLM Integration Issues

### Missing or Invalid API Keys

**Symptoms:**

- "API key not found" errors
- LLM features not working

**Solutions:**

1. Verify at least one LLM provider is configured:

   ```bash
   grep -E "OPENAI_API_KEY|ANTHROPIC_API_KEY" backend/.env
   ```

2. Test API key validity:

   ```bash
   # For OpenAI
   curl https://api.openai.com/v1/models \
     -H "Authorization: Bearer $OPENAI_API_KEY"
   ```

3. Check environment variables are loaded:
   ```bash
   cd backend
   poetry run python -c "import os; print('Keys:', [k for k in os.environ if 'API_KEY' in k])"
   ```

### Model Configuration Issues

**Symptoms:**

- "Model not found" errors
- Wrong model being used

**Solutions:**

1. Check available models in the database:

   ```sql
   SELECT name, model_id, provider FROM completion_models WHERE is_active = true;
   ```

2. Verify model configuration in spaces:
   ```sql
   SELECT s.name, cm.name as model_name
   FROM spaces s
   JOIN completion_models cm ON s.completion_model_id = cm.id;
   ```

## Frontend Issues

### Build Failures

**Symptoms:**

- pnpm build fails
- Missing dependencies

**Solutions:**

1. Clean install dependencies:

   ```bash
   cd frontend
   rm -rf node_modules pnpm-lock.yaml
   pnpm install
   pnpm run setup
   ```

2. Check Node.js version (should be 18+):
   ```bash
   node --version
   ```

### Cannot Connect to Backend

**Symptoms:**

- API calls fail
- "Network error" in console

**Solutions:**

1. Verify backend URL in frontend config:

   ```bash
   grep INTRIC_BACKEND_URL frontend/apps/web/.env
   # Should be http://localhost:8000 for dev
   ```

2. Check CORS settings if in production
3. Verify backend is accessible:
   ```bash
   curl http://localhost:8000/api/v1/health
   ```

### WebSocket Connection Issues

**Symptoms:**

- Real-time updates not working
- WebSocket errors in console

**Solutions:**

1. Check WebSocket endpoint:

   ```javascript
   // Should connect to ws://localhost:8000/ws
   ```

2. Verify no proxy is blocking WebSocket upgrade (if using HAProxy)
3. Check browser console for specific errors
4. Ensure backend WebSocket handlers are properly configured

## Backend Issues

### Import Errors

**Symptoms:**

- ModuleNotFoundError
- ImportError

**Solutions:**

1. Ensure you're in Poetry environment:

   ```bash
   cd backend
   poetry shell
   # or use poetry run prefix
   ```

2. Reinstall dependencies:
   ```bash
   poetry install
   ```

### Gunicorn Worker Timeout

**Symptoms:**

- Worker timeout errors
- 502 errors after 30 seconds

**Solutions:**

1. Increase worker timeout in run.sh:

   ```bash
   --timeout 120  # Increase from default
   ```

2. Check for long-running synchronous operations
3. Consider using background tasks for heavy operations

## Worker Issues

### ARQ Worker Not Processing Jobs

**Symptoms:**

- Tasks stuck in queue
- Background jobs not completing

**Solutions:**

1. Check worker is running:

   ```bash
   ps aux | grep arq
   ```

2. Verify Redis connectivity:

   ```bash
   redis-cli ping
   ```

3. Check job queue:

   ```bash
   redis-cli
   > KEYS arq:*
   > LLEN arq:queue:default
   ```

4. Monitor worker logs:
   ```bash
   journalctl -u intric-worker -f
   ```

### Task Failures

**Symptoms:**

- Jobs marked as failed
- Retry count exceeded

**Solutions:**

1. Check task implementation for errors
2. Verify external dependencies (file paths, API access)
3. Increase task timeout if needed
4. Check worker has necessary permissions

## Performance Issues

### Slow Vector Search

**Symptoms:**

- Search queries timeout
- High CPU usage during search

**Solutions:**

1. Check vector index exists:

   ```sql
   \d info_blob_chunks
   ```

2. Create appropriate index:

   ```sql
   CREATE INDEX ON info_blob_chunks USING ivfflat (embedding vector_cosine_ops);
   ```

3. Tune index parameters:
   ```sql
   ALTER INDEX info_blob_chunks_embedding_idx SET (lists = 100);
   ```

### High Memory Usage

**Symptoms:**

- OOM killer terminates services
- Slow response times

**Solutions:**

1. Check memory usage:

   ```bash
   free -h
   top -o %MEM
   ```

2. Tune PostgreSQL memory:

   ```bash
   # postgresql.conf
   shared_buffers = 1GB
   effective_cache_size = 3GB
   ```

3. Limit Gunicorn workers based on available RAM
4. Configure connection pooling properly

## Common Error Messages

### "SQLSTATE[08006] - connection refused"

- PostgreSQL not running or wrong connection params
- Check POSTGRES_HOST and POSTGRES_PORT

### "TypeError: expected string or bytes-like object"

- Usually indicates None value where string expected
- Check for missing environment variables

### "asyncpg.exceptions.UndefinedColumnError"

- Database schema out of sync
- Run migrations: `poetry run alembic upgrade head`

### "redis.exceptions.ConnectionError"

- Redis not running or wrong host/port
- Check REDIS_HOST and REDIS_PORT

### "413 Request Entity Too Large"

- File upload exceeds limit
- Check UPLOAD_MAX_FILE_SIZE in backend config
- Adjust proxy settings if using HAProxy or other load balancer

## Getting Help

If you're still experiencing issues:

1. **Check existing resources:**

   - GitHub Issues: [link]
   - Documentation: `/docs` folder

2. **Collect diagnostic information:**

   ```bash
   # System info
   uname -a
   python --version
   node --version

   # Service logs
   journalctl -u intric-backend --since "1 hour ago" > backend.log

   # Database status
   psql -c "SELECT version();"
   ```

3. **Report issues with:**

   - Clear description of the problem
   - Steps to reproduce
   - Error messages and logs
   - Environment details (OS, versions)
   - Configuration (sanitized)

4. **Community support:**
   - GitHub Discussions
   - Email: [community contact]
