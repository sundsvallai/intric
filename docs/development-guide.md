# Intric Development Guide

## TLDR
- **Prerequisites**: Python 3.10+, Node.js 20+, Docker, Poetry, pnpm 8.9.0, Git, libmagic, ffmpeg
- **Quick Setup**: 
  1. Clone repo
  2. Start infrastructure (`docker compose up -d` in backend directory)
  3. Configure backend:
     ```bash
     cd backend
     poetry install
     cp .env.template .env
     poetry run python init_db.py
     poetry run start
     ```
  4. Configure frontend:
     ```bash
     cd frontend
     pnpm run setup
     # Setup .env file in frontend/apps/web directory
     cd apps/web
     cp .env.example .env
     cd ../../
     pnpm -w run dev
     ```
  5. Access at http://localhost:3000 (login: user@example.com / Password1!)
  6. (Optional) Run worker: `poetry run arq src.intric.worker.arq.WorkerSettings`
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
- Node.js 20 or higher
- Poetry (Python dependency management)
- pnpm 8.9.0 (Node.js package manager)
- Docker and Docker Compose
- Git
- libmagic and ffmpeg

### Additional system requirements
To be able to use the platform to the fullest, install `libmagic` and `ffmpeg`:

```bash
sudo apt-get install libmagic1
sudo apt-get install ffmpeg
```

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/intric.git
   cd intric
   ```

2. **Set up infrastructure services**:
   ```bash
   cd backend
   docker compose up -d
   ```
   This starts PostgreSQL with pgvector extension and Redis for local development.

3. **Set up backend**:
   ```bash
   cd backend
   
   # Install dependencies using Poetry
   poetry install
   
   # Copy environment file and edit as needed
   cp .env.template .env
   
   # Initialize database (first time only)
   poetry run python init_db.py
   
   # Start the backend service
   poetry run start
   ```

4. **Set up frontend**:
   ```bash
   cd frontend
   
   # Install dependencies
   pnpm run setup
   
   # Copy environment file and edit as needed
   cd apps/web
   cp .env.example .env
   cd ../../
   
   # Start the frontend development server
   pnpm -w run dev
   ```

5. **Start the worker (optional)**:
   ```bash
   cd backend
   poetry run arq src.intric.worker.arq.WorkerSettings
   ```

6. **Access the application**:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8123
   - API documentation: http://localhost:8123/docs
   - **Default login credentials**: 
     - Email: `user@example.com` 
     - Password: `Password1!`

> **Note**: These login credentials are automatically created when you run the database initialization step.

### Environment Setup for Different Workflows

For detailed information about environment configuration and variables, please refer to the [Configuration Guide](./configuration.md).

#### Local Development Environment

For local development without Docker:

1. **Backend Development**:
   ```bash
   cd backend
   
   # Copy environment file
   cp .env.template .env
   
   # Customize your local environment variables
   # Note: This configuration uses localhost for database and Redis
   nano .env
   
   # Start infrastructure services only
   docker compose up -d
   
   # Run backend directly with Poetry
   poetry run start
   ```

2. **Frontend Development**:
   ```bash
   cd frontend
   
   # Copy environment file
   cd apps/web
   cp .env.example .env
   
   # Customize your local environment variables
   nano .env
   cd ../../
   
   # Start frontend development server
   pnpm -w run dev
   ```

### Using Devcontainer for Development

The project is configured to use a devcontainer, which allows you to develop in a consistent environment using Visual Studio Code and Docker. Follow these steps to get started:

1. **Install Prerequisites**:
   - Ensure you have Docker installed on your machine.
   - Install Visual Studio Code and the Remote - Containers extension.

2. **Copy Environment Files**:
   - Before starting development, you need to set up your environment files:
     ```bash
     # In the backend directory
     cp .env.template .env

     # In the frontend/apps/web directory
     cp .env.example .env
     ```
   - Remember to update these .env files with appropriate values.

3. **Open the Project in a Devcontainer**:
   - Open the project folder in Visual Studio Code.
   - When prompted, or by clicking on the green icon in the bottom-left corner, select "Reopen in Container".
   - This will build the devcontainer as defined in `.devcontainer/devcontainer.json` and `.devcontainer/docker-compose.yml`.

4. **Accessing Services**:
   - The devcontainer setup will automatically forward ports 3000 and 8123, allowing you to access the frontend and any other services running on these ports.

5. **Post-Create Commands**:
   - After the container is created, the `postCreateCommand` specified in `.devcontainer/devcontainer.json` will run, setting up the environment.

6. **Developing**:
   - You can now develop as usual within the container. The environment will have all necessary dependencies installed and configured.

   **Important Notes**:
   - Database migrations are not run automatically. After the container is created, you'll need to run:
     ```bash
     cd backend
     poetry run python init_db.py
     ```
   - You'll need to manually start both the backend and frontend services in separate terminal windows:

     For the backend:
     ```bash
     cd backend
     poetry run start
     ```

     For the frontend:
     ```bash
     cd frontend
     pnpm run dev
     ```

     Running the frontend and backend in separate terminal windows gives you better control over each service's lifecycle. This makes it easier to restart individual services when needed, such as after installing new dependencies or when troubleshooting issues.

7. **Stopping the Devcontainer**:
   - To stop the devcontainer, simply close Visual Studio Code or use the "Remote - Containers: Reopen Folder Locally" command.

This setup ensures that all developers work in the same environment, reducing "it works on my machine" issues.

## Project Structure

### Repository Organization

The repository follows a domain-driven organization pattern:

```
intric/
├── backend/                 # Backend Python application
│   ├── src/                 # Source code
│   │   └── intric/          # Main package
│   │       ├── server/      # API server implementation
│   │       ├── database/    # Database models and migrations
│   │       ├── assistants/  # Assistants domain
│   │       ├── sessions/    # Chat sessions domain
│   │       ├── spaces/      # Collaborative spaces domain
│   │       ├── files/       # File handling domain
│   │       ├── users/       # User management domain
│   │       ├── worker/      # Background task workers
│   │       └── ...          # Other domain modules
│   ├── docker-compose.yml   # Development infrastructure
│   └── pyproject.toml       # Python dependencies
├── frontend/                # Frontend SvelteKit application
│   ├── apps/                # Application code
│   │   └── web/             # Main web application
│   │       ├── src/         # Source code
│   │       │   ├── lib/     # Reusable components and utilities
│   │       │   └── routes/  # Application routes
│   │       └── .env.example # Environment template
│   └── package.json         # Node.js dependencies
├── docker-compose.yml       # Production deployment configuration
└── .env.production.example  # Example environment variables
```

For details on building Docker images and deployment configuration, please refer to the [Deployment Guide](./deployment-guide.md).

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

1. **Domain Entities** (`src/intric/domain_name/domain_name.py`) - Core business models
2. **Repositories** (`src/intric/domain_name/domain_name_repo.py`) - Data access layer
3. **Services** (`src/intric/domain_name/domain_name_service.py`) - Business logic
4. **API Routes** (`src/intric/domain_name/api/domain_name_router.py`) - HTTP endpoints

#### API Structure

The API layer is organized by domain:

1. **API Models** (`src/intric/domain_name/api/domain_name_models.py`) - Request/response schemas
2. **API Routes** (`src/intric/domain_name/api/domain_name_router.py`) - API endpoints
3. **Assemblers** (`src/intric/domain_name/api/domain_name_assembler.py`) - Transform between domain and API models

#### Background Processing

Long-running tasks are handled by a worker service using ARQ:

1. Tasks are defined in each domain's corresponding worker module
2. The worker process is run separately in production
3. Task statuses are tracked in Redis

#### Database

The database schema is managed with SQLAlchemy and Alembic:

1. Models are defined in each domain's models module
2. Migrations are stored in the `alembic/versions/` directory
3. For vector embeddings, the pgvector extension is used

### Running Backend Tests

```bash
cd backend
poetry run pytest
```

### Database Migrations

We use [alembic](https://alembic.sqlalchemy.org/en/latest/) for our database migrations. When you make changes to the database models, you'll need to generate and apply migrations:

```bash
# Generate a new migration
poetry run alembic revision --autogenerate -m "description of changes"

# Apply migrations
poetry run alembic upgrade head
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

For more details on the domain-driven design approach, see the [Domain-Driven Design document](./domain-driven-design.md).

### Feature Architecture

The architecture for each feature strives to look like this:

```
feature_x/
├── api/
│   ├── feature_x_models.py
│   ├── feature_x_assembler.py
│   └── feature_x_router.py
├── feature_x.py
├── feature_x_repo.py
├── feature_x_service.py
└── feature_x_factory.py
```

An example of this can be seen in the `Spaces` feature.

#### Function of each module

- **feature_x.py** - The main class, the main domain object. Domain logic pertaining to how the feature works should live here.
- **feature_x_repo.py** - Dependency inversion of database dependency. Should input a `Feature_x` class (or an `id`) and return that same class.
- **feature_x_service.py** - Responsible for connecting this domain object with other related ones.
- **feature_x_factory.py** - Factory class. Creates the domain object.
- **feature_x_router.py** - Specifies the endpoints.
- **feature_x_models.py** - Definition of the API schema.
- **feature_x_assembler.py** - Translates domain objects to the API schema, allowing for the schema to change without affecting the shape of the domain object.

### Dependency Injection

We use a [dependency injection framework](https://python-dependency-injector.ets-labs.org/index.html) to handle dependency injection for us. This framework creates all the necessary classes and handles their inter-dependency. This is typically done in the router.

### Connecting Features

Add the router in the main router (located at `src/intric/server/routers/__init__.py`) to connect the endpoints to the application.

### Microservices

The application is structured as a set of loosely coupled services:

1. **Frontend Service** - SvelteKit application served by Nginx
2. **Backend API** - FastAPI application handling business logic
3. **Worker Service** - Background task processor
4. **Database** - PostgreSQL with pgvector
5. **Cache** - Redis for task queue and caching

For the complete architectural overview, refer to the [Architecture document](./architecture.md).

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

For more detailed contribution guidelines, see the [Contributing document](./contributing.md).

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

### Troubleshooting

For common development issues and their solutions, refer to the [Troubleshooting Guide](./troubleshooting.md).
