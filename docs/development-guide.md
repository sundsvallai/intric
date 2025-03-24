# Intric Development Guide

## TLDR
- **Prerequisites**: Python 3.10+, Node.js 16+, Docker, Poetry, pnpm, Git
- **Quick Setup**: 
  1. Clone repo
  2. Start infrastructure (`docker-compose up -d` in backend directory)
  3. Configure backend (Poetry + database init)
  4. Configure frontend (pnpm)
  5. Access at http://localhost:3000 (frontend) and http://localhost:8123 (API)
- **Architecture**: Domain-driven design with clearly separated backend and frontend services

This guide provides detailed instructions for setting up a development environment for the Intric platform and contributing to the project.

## Table of Contents
- [Development Environment Setup](#development-environment-setup)
- [Project Structure](#project-structure)
- [Backend Development](#backend-development)
- [Frontend Development](#frontend-development)
- [Architectural Patterns](#architectural-patterns)
- [Testing](#testing)
- [Documentation](#documentation)
- [Contributing Guidelines](#contributing-guidelines)

## Development Environment Setup

### Prerequisites
- Python 3.10 or higher
- Node.js 16 or higher
- Poetry (Python dependency management)
- pnpm (Node.js package manager)
- Docker and Docker Compose
- Git

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/intric.git
   cd intric
   ```

2. **Set up infrastructure services**:
   ```bash
   cd backend
   docker-compose up -d
   ```
   This starts PostgreSQL with pgvector extension and Redis for local development.

3. **Set up backend**:
   ```bash
   cd backend
   
   # Install dependencies using Poetry
   poetry install
   
   # Copy environment file and edit as needed
   cp .env.example .env
   
   # Initialize database (first time only)
   poetry run python -m app.database.init
   
   # Start the backend service
   poetry run uvicorn app.main:app --reload --port 8123
   ```

4. **Set up frontend**:
   ```bash
   cd frontend
   
   # Install dependencies
   pnpm install
   
   # Copy environment file and edit as needed
   cp .env.example .env
   
   # Start the frontend development server
   pnpm dev
   ```

5. **Access the application**:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8123
   - API documentation: http://localhost:8123/docs

### Environment Setup for Different Workflows

Intric provides environment templates for different development and deployment scenarios:

#### Local Development Environment

For local development without Docker:

1. **Backend Development**:
   ```bash
   cd backend
   
   # Copy environment file
   cp .env.example .env
   
   # Customize your local environment variables
   # Note: This configuration uses localhost for database and Redis
   nano .env
   
   # Start infrastructure services only
   docker-compose up -d
   
   # Run backend directly with Poetry
   poetry run uvicorn intric.server.main:app --reload --port 8123
   ```

2. **Frontend Development**:
   ```bash
   cd frontend
   
   # Copy environment file
   cp .env.example .env
   
   # Customize your local environment variables
   nano .env
   
   # Start frontend development server
   pnpm dev
   ```

#### Docker Testing During Development

To test your changes in Docker containers:

```bash
# From project root
cp .env.example .env

# Set local registry and development image tag
echo "NEXUS_REGISTRY=localhost" >> .env
echo "IMAGE_TAG=dev" >> .env

# Build images with the build script
./build_and_push.sh

# Run the entire stack
docker compose up -d
```

This approach allows you to test the full stack exactly as it would run in production, but using your local development images.

### Building Docker Images

When you need to build and test your changes in Docker containers or prepare images for staging/production environments, Intric provides two approaches:

#### Option 1: Using the build_and_push.sh Script (Recommended)

The repository includes an optimized build script that follows Docker best practices:

```bash
# Make the script executable (first time only)
chmod +x build_and_push.sh

# Set required environment variables
export NEXUS_REGISTRY="your.nexus.registry.com"
# Optional - script can auto-detect version from Git
export IMAGE_TAG="dev-$(git rev-parse --short HEAD)"  
export NEXUS_USERNAME="your_username"  # Optional
export NEXUS_PASSWORD="your_password"  # Optional

# Run the script
./build_and_push.sh
```

Benefits of using this script during development:
- Uses Docker BuildKit for faster, more efficient builds
- Optimizes caching between builds, resulting in quicker iteration
- Intelligent versioning strategy:
  - Automatically uses Git tags if available
  - For development branches, creates unique tags with branch name, commit hash and date
  - Only tags as "latest" for main/master branches or semantic versions
- Provides colorized output with helpful progress and error messages

#### Option 2: Building Images Manually

For more control over the build process:

```bash
# Backend image
cd backend
docker build -t intric/backend:dev .

# Frontend image
cd ../frontend
docker build -t intric/frontend:dev .
```

### Testing Built Images Locally

After building the images, you can test them locally:

```bash
# Create a local .env file with test configuration
cp .env.example .env
nano .env  # Edit configuration as needed

# Run the stack using your locally built images
export NEXUS_REGISTRY="localhost"
export IMAGE_TAG="dev"
docker compose up -d
```

### Environment Configuration

Intric uses clearly named environment files to distinguish between local development and production settings:

#### Local Development Files
1. `backend/.env.local.example`
   - Contains configuration for running backend services directly on your machine
   - Points to localhost for database and Redis connections
   - Includes debug-level logging and development-specific settings
   - **Usage**: Copy to `backend/.env` for local development

2. `frontend/.env.local.example`
   - Contains frontend development settings
   - Points to local backend service
   - Includes development-specific features
   - **Usage**: Copy to `frontend/.env` for local development

#### Production Configuration
- `.env.production.example` (in root directory)
  - Contains full stack configuration for containerized deployment
  - Uses internal Docker network hostnames
  - Includes all service configurations
  - **Usage**: Copy to `.env` in root directory for production deployment

### Setting Up Your Development Environment

1. **Backend Setup**:
   ```bash
   cd backend
   cp .env.local.example .env  # Copy the local development template
   # Edit .env to set your API keys and other configurations
   ```

2. **Frontend Setup**:
   ```bash
   cd frontend
   cp .env.local.example .env  # Copy the local development template
   # Edit .env to configure frontend settings
   ```

> **Note**: Never commit `.env` files to version control. The example files provide templates with safe default values and clear documentation of required variables.

## Project Structure

### Repository Organization

The repository follows a domain-driven organization pattern:

```
intric/
├── backend/                # Backend Python application
│   ├── src/                # Source code
│   │   └── intric/         # Main package
│   │       ├── server/     # API server implementation
│   │       ├── database/   # Database models and migrations
│   │       ├── assistants/ # Assistants domain
│   │       ├── sessions/   # Chat sessions domain
│   │       ├── spaces/     # Collaborative spaces domain
│   │       ├── files/      # File handling domain
│   │       ├── users/      # User management domain
│   │       ├── worker/     # Background task workers
│   │       └── ...         # Other domain modules
│   ├── docker-compose.yml  # Development infrastructure
│   └── pyproject.toml      # Python dependencies
├── frontend/               # Frontend SvelteKit application
│   ├── src/                # Source code
│   │   ├── lib/            # Reusable components and utilities
│   │   │   ├── components/ # UI components
│   │   │   └── stores/     # State management stores
│   │   └── routes/         # Application routes
│   └── package.json        # Node.js dependencies
├── docker-compose.yml      # Production deployment configuration
└── .env.example            # Example environment variables
```

## Backend Development

### Technology Stack

- **Framework**: FastAPI
- **ORM**: SQLAlchemy with Alembic for migrations
- **Database**: PostgreSQL with pgvector extension
- **Task Queue**: ARQ (Redis-based)
- **Dependency Management**: Poetry
- **Testing**: pytest

### Key Components

#### Domain-Driven Structure

The backend follows domain-driven design principles with a clear separation of concerns:

1. **Domain Entities** (`app/domain_name/domain_name.py`) - Core business models
2. **Repositories** (`app/domain_name/domain_name_repo.py`) - Data access layer
3. **Services** (`app/domain_name/domain_name_service.py`) - Business logic
4. **API Routes** (`app/domain_name/api/domain_name_router.py`) - HTTP endpoints

#### API Structure

The API layer is organized by domain:

1. **API Models** (`app/domain_name/api/domain_name_models.py`) - Request/response schemas
2. **API Routes** (`app/domain_name/api/domain_name_router.py`) - API endpoints
3. **Assemblers** (`app/domain_name/api/domain_name_assembler.py`) - Transform between domain and API models

#### Background Processing

Long-running tasks are handled by a worker service using ARQ:

1. Tasks are defined in each domain's corresponding worker module
2. The worker process is run separately in production
3. Task statuses are tracked in Redis

#### Database

The database schema is managed with SQLAlchemy and Alembic:

1. Models are defined in each domain's models module
2. Migrations are stored in `app/database/migrations/`
3. For vector embeddings, the pgvector extension is used

### Running Backend Tests

```bash
cd backend
poetry run pytest
```

## Frontend Development

### Technology Stack

- **Framework**: SvelteKit
- **Package Manager**: pnpm
- **UI Components**: Custom component library
- **HTTP Client**: Fetch API with custom wrapper
- **State Management**: Svelte stores
- **Styling**: CSS/SCSS

### Key Components

#### UI Components

The frontend uses a component-based architecture:

- **Layout Components** - Page layout and structure
- **Feature Components** - Domain-specific UI components
- **Common UI Components** - Reusable UI elements
- **Form Components** - Form inputs and validation

#### State Management

Svelte stores are used for state management:

- **Authentication** - User authentication state
- **Settings** - User preferences
- **Assistants** - Assistant configurations
- **Session** - Current chat session

#### API Integration

API requests are handled through service modules:

- **API Service** - Base API request handling
- **Auth Service** - Authentication operations
- **Assistant Service** - Assistant management
- **Session Service** - Chat session operations

### Running Frontend Tests

```bash
cd frontend
pnpm test
```

## Architectural Patterns

### Domain-Driven Design

Intric follows domain-driven design principles:

1. **Ubiquitous Language** - Consistent terminology across code and documentation
2. **Bounded Contexts** - Clear domain boundaries
3. **Entities and Value Objects** - Domain models with identity or value semantics
4. **Repositories** - Data access abstraction
5. **Domain Services** - Business logic operations

### Microservices

The application is structured as a set of loosely coupled services:

1. **Frontend Service** - SvelteKit application served by Nginx
2. **Backend API** - FastAPI application handling business logic
3. **Worker Service** - Background task processor
4. **Database** - PostgreSQL with pgvector
5. **Cache** - Redis for task queue and caching

### Communication Flow

Components communicate through these channels:

1. **Frontend to Backend** - HTTP/REST API
2. **Backend to Worker** - Redis message queue
3. **Real-time Updates** - Server-Sent Events (SSE)
4. **Database Access** - SQLAlchemy ORM

### Security Model

The security model includes:

1. **Authentication** - JWT token-based authentication
2. **Authorization** - Role-based access control
3. **API Keys** - For programmatic access

## Testing

### Testing Strategy

Intric uses a comprehensive testing approach:

1. **Unit Tests** - Test individual functions and classes
2. **Integration Tests** - Test component interactions
3. **API Tests** - Test API endpoints
4. **End-to-End Tests** - Test complete user flows

### Test Organization

Tests are organized following the domain structure:

```
tests/
├── unit/                     # Unit tests
│   └── domain_name/          # Tests for specific domain
├── integration/              # Integration tests
│   └── domain_name/          # Tests for specific domain
└── api/                      # API tests
    └── domain_name/          # Tests for domain API
```

### Test Coverage

Aim for high test coverage, especially for critical paths:

1. **Backend** - Minimum 80% code coverage
2. **Frontend** - Test all critical user flows
3. **Automated Testing** - CI pipeline runs tests on each commit

## Documentation

### API Documentation

The API is documented using OpenAPI/Swagger:

- Access at `http://localhost:8123/docs` during development
- Generated from code annotations in FastAPI routes

### Code Documentation

Follow these documentation guidelines:

1. **Docstrings** - Use Python docstrings for functions and classes
2. **Comments** - Add comments for complex logic
3. **Type Hints** - Use Python type hints throughout the codebase

## Contributing Guidelines

### Development Workflow

1. **Create a Feature Branch** - Branch from `develop` for new features
2. **Write Tests** - Add tests for new functionality
3. **Submit a Pull Request** - Target the `develop` branch
4. **Code Review** - At least one review is required
5. **CI Checks** - All tests must pass

### Coding Standards

1. **Python Code** - Follow PEP 8 style guide
2. **Frontend Code** - Follow the project's ESLint configuration
3. **Commit Messages** - Use conventional commit format

### Development Best Practices

1. **Feature Flags** - Use feature flags for gradual rollout
2. **Backward Compatibility** - Maintain API compatibility
3. **Performance** - Consider performance implications
4. **Security** - Follow security best practices

### Getting Help

If you need assistance during development:

1. **Check Issues** - Look for similar issues on GitHub
2. **Join Community** - Participate in the development community
3. **Documentation** - Refer to the project documentation