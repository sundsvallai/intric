# Base image for installing dependencies and building the app
FROM node:22-slim@sha256:483b3a6c706e268e57920ab906f72564ecb1dbc715607aa9b26cfa2a43d6e65d as base
WORKDIR /app

# Build stage (Dependencies will be installed here)
FROM base AS build
# Install pnpm globally in the build stage
RUN npm install -g pnpm@9.12.3 --no-progress

# Copy necessary package manifests and lockfile first for layer caching
COPY package.json pnpm-lock.yaml ./
COPY apps/web/package.json ./apps/web/
COPY packages/intric-js/package.json ./packages/intric-js/
COPY packages/ui/package.json ./packages/ui/

# Copy the rest of the source code
COPY . .

# Configure pnpm store directory (optional, might save space if store isn't needed later)
RUN pnpm config set store-dir /tmp/pnpm-store
# Install dependencies using the lockfile
RUN pnpm install --frozen-lockfile

# Ensure node_modules binaries are in the PATH for subsequent RUN commands
ENV PATH="/app/node_modules/.bin:${PATH}"

# Build UI packages first (assuming this is necessary)
RUN pnpm run --filter @intric/ui... build

# Build the web application
ENV NODE_ENV=production
RUN pnpm run --filter @intric/web build

# ------------------------------------------------------------------------------
# Production stage (Nginx)
FROM nginx:1.26-alpine-perl AS final
# Copy custom Nginx site configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built SvelteKit assets from the build stage
COPY --from=build /app/apps/web/build /usr/share/nginx/html

# Update nginx in the site config to listen on port 3000 instead of 80
RUN sed -i.bak 's/listen\(.*\)80;/listen 3000;/' /etc/nginx/conf.d/default.conf

# --- FIX: Modify existing pid directive instead of adding a duplicate ---
# Use sed to find the line starting with 'pid' in the main nginx.conf
# and replace the path with '/tmp/nginx.pid'.
RUN sed -i 's#^pid .*;#pid /tmp/nginx.pid;#' /etc/nginx/nginx.conf

# Set proper permissions for directories Nginx needs to write to (cache, logs).
RUN chown -R nginx:nginx /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Switch to the non-root user 'nginx'
USER nginx

# Expose the port Nginx will listen on
EXPOSE 3000

# Command to run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]