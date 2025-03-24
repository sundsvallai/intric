FROM node:22-slim@sha256:483b3a6c706e268e57920ab906f72564ecb1dbc715607aa9b26cfa2a43d6e65d as base
WORKDIR /app

# Install dependencies stage
FROM base AS dependencies
RUN npm install -g pnpm@8.9.0

# Copy package files for dependency installation
COPY package.json pnpm-lock.yaml ./
COPY apps/web/package.json ./apps/web/
COPY packages/intric-js/package.json ./packages/intric-js/
COPY packages/ui/package.json ./packages/ui/

# Set pnpm store directory and install dependencies
RUN pnpm config set store-dir /tmp/pnpm-store
RUN pnpm install --frozen-lockfile

# Build stage
FROM base AS build
RUN npm install -g pnpm@8.9.0
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# Build UI packages first
RUN pnpm run --filter @intric/ui... build

# Build the web application
ARG INTRIC_BACKEND_URL
ENV INTRIC_BACKEND_URL=${INTRIC_BACKEND_URL}
ENV NODE_ENV=production
RUN pnpm run --filter @intric/web build

# Production stage
FROM nginx:stable-alpine-perl@sha256:f1235d7aaefb722e4e61e0f7e3fa611242f64442c7b8a99413a57a379538353e
# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built SvelteKit assets
COPY --from=build /app/apps/web/build /usr/share/nginx/html

# Update nginx to listen on port 3000
RUN sed -i.bak 's/listen\(.*\)80;/listen 3000;/' /etc/nginx/conf.d/default.conf

# Set proper permissions for nginx
RUN chown -R nginx:nginx /var/cache/nginx /var/run /var/log/nginx /etc/nginx/conf.d

# Switch to non-root user
USER nginx

# Expose the port
EXPOSE 3000

# Run nginx in exec form as recommended
CMD ["nginx", "-g", "daemon off;"]