# Intric Development Guide

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

## Project Structure

### Repository Organization

```
intric/
├── backend/                # Backend Python application
│   ├── app/                # Application code
│   │   ├── api/            # API endpoints
│   │   ├── core/           # Core functionality
│   │   ├── database/       # Database models and migrations
│   │   ├── services/       # Business logic services
│   │   └── worker/         # Background task workers
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

#### API Structure

The backend follows a layered architecture:

1. **API Routes** (`app/api/`) - Handle HTTP requests and responses
2. **Services** (`app/services/`) - Implement business logic
3. **Models** (`app/database/models/`) - Define database schema
4. **Core** (`app/core/`) - Common utilities and configurations

#### Background Processing

Long-running tasks are handled by a worker service using ARQ:

1. Tasks are defined in `app/worker/tasks.py`
2. The worker process is run separately in production
3. Task statuses are tracked in Redis

#### Database

The database schema is managed with SQLAlchemy and Alembic:

1. Models are defined in `app/database/models/`
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

The frontend uses a custom component library located in `frontend/src/lib/components/`:

- **Layout** - Page layout components
- **UI** - Basic UI elements (buttons, inputs, etc.)
- **Session** - Chat session components
- **Assistant** - Assistant configuration components

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

### Microservices

Intric follows a microservices architecture with these main components:

1. **Frontend Service** - Svelte application served by Nginx
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
4. **Rate Limiting** - To prevent abuse

## Testing

### Testing Strategy

Intric uses a comprehensive testing approach:

1. **Unit Tests** - Test individual functions and classes
2. **Integration Tests** - Test component interactions
3. **API Tests** - Test API endpoints
4. **End-to-End Tests** - Test complete user flows

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
