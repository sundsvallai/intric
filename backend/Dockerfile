# Use the AMD64 platform explicitly for the builder stage
FROM --platform=linux/amd64 python:3.11-slim-bullseye as builder

# Install system dependencies for building, including curl for rustup
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libffi-dev \
    python3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (which will include Cargo)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Ensure Cargo is on the PATH for all subsequent commands
ENV PATH="/root/.cargo/bin:${PATH}"

# (Optional) Verify that Cargo is installed correctly
RUN cargo --version

# Install Poetry with pip now that Cargo is available in the PATH
RUN pip install --no-cache-dir poetry==1.6.1

# Set working directory
WORKDIR /app

# Copy dependency definition files to leverage Docker cache
COPY pyproject.toml poetry.lock ./

# Configure Poetry to not create a virtual environment
RUN poetry config virtualenvs.create false

# Install production dependencies only (excluding the project itself)
RUN poetry install --no-root --no-interaction --no-ansi --only main

# ------------------------------------------------------------------------------
# Final Image (Runtime)
# Use the AMD64 platform explicitly here as well
FROM --platform=linux/amd64 python:3.10-slim-bullseye

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    libmagic1 \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy installed dependencies and binaries from the builder stage
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the rest of the application code
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app/src

# Create a data directory with appropriate permissions
RUN mkdir -p /app/data && chmod 777 /app/data

# Create a non-root user and set ownership of the app directory
RUN groupadd -r intric && \
    useradd -r -g intric -d /app -s /bin/bash intric && \
    chown -R intric:intric /app

USER intric

# Expose the application port
EXPOSE 8123

# Command to run the application (using exec form as recommended)
CMD ["poetry", "run", "uvicorn", "intric.server.main:app", "--host", "0.0.0.0", "--port", "8123"]
