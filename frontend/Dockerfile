FROM node:18-slim as base
WORKDIR /app

# Install dependencies stage
FROM base AS dependencies
RUN npm install -g pnpm@9.12.3

# Copy package files for dependency installation
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY apps/web/package.json ./apps/web/
COPY packages/intric-js/package.json ./packages/intric-js/
COPY packages/ui/package.json ./packages/ui/

# Set pnpm store directory and install dependencies
RUN pnpm config set store-dir /tmp/pnpm-store
RUN pnpm install --frozen-lockfile

# Build stage
FROM base AS build
RUN npm install -g pnpm@9.12.3
COPY --from=dependencies /app/ ./
COPY . .

# Build UI packages first
RUN pnpm run --filter @intric/ui... build

# Build the web application
ENV NODE_ENV=production
# Set public env variables at build time for client-side code
ARG INTRIC_BACKEND_URL
ENV INTRIC_BACKEND_URL=${INTRIC_BACKEND_URL}
RUN pnpm run --filter @intric/web build

# Production stage
FROM node:18-slim

WORKDIR /app

# Copy only the build output and necessary files for production
COPY --from=build /app/apps/web/build ./build
COPY --from=build /app/apps/web/package.json .

# Expose the port
EXPOSE 3000

# Start the SvelteKit app
CMD ["node", "build"]
