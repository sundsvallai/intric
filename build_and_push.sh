#!/bin/bash
# build_and_push.sh - Script for building and pushing Intric Docker images to Nexus registry
# This script follows Docker best practices for efficient building and pushing

set -e  # Exit on any error

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =====================================================
# Environment Variables and Configuration
# =====================================================

# Default values (will be used if not provided as environment variables)
DEFAULT_IMAGE_TAG="latest"
DEFAULT_NEXUS_REGISTRY="localhost:5000" # Default to local registry if not specified

# Use environment variables or defaults
NEXUS_REGISTRY=${NEXUS_REGISTRY:-$DEFAULT_NEXUS_REGISTRY}
IMAGE_TAG=${IMAGE_TAG:-$DEFAULT_IMAGE_TAG}

# =====================================================
# Versioning Strategy Detection
# =====================================================

# Determine if we're using a Git tag as version
if [ -z "$IMAGE_TAG" ] || [ "$IMAGE_TAG" = "latest" ]; then
  # Check if we're on a Git tag
  GIT_TAG=$(git describe --exact-match --tags 2>/dev/null || echo "")
  if [ ! -z "$GIT_TAG" ]; then
    echo -e "${BLUE}Detected Git tag: ${GIT_TAG}${NC}"
    IMAGE_TAG=$(echo $GIT_TAG | sed 's/^v//')
    # Also check if it follows semantic versioning (X.Y.Z)
    if [[ $IMAGE_TAG =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo -e "${GREEN}Using semantic version: ${IMAGE_TAG}${NC}"
    fi
  else
    # If no specific version, use git commit hash
    GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    BUILD_DATE=$(date +%Y%m%d)
    
    if [ "$IMAGE_TAG" = "latest" ]; then
      # For development builds, use branch-commit-date format
      if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
        IMAGE_TAG="${CURRENT_BRANCH}-${GIT_COMMIT}-${BUILD_DATE}"
        echo -e "${YELLOW}Using development tag: ${IMAGE_TAG}${NC}"
      else
        echo -e "${YELLOW}Using tag: ${IMAGE_TAG}${NC}"
      fi
    fi
  fi
fi

# =====================================================
# Parameter Validation
# =====================================================

if [ -z "$NEXUS_REGISTRY" ]; then
  echo -e "${RED}Error: NEXUS_REGISTRY environment variable is required${NC}"
  exit 1
fi

echo -e "${BLUE}Building and pushing images to: ${NEXUS_REGISTRY}${NC}"
echo -e "${BLUE}Using image tag: ${IMAGE_TAG}${NC}"

# =====================================================
# Registry Authentication
# =====================================================

# Login to Nexus registry if credentials are available
if [ ! -z "$NEXUS_USERNAME" ] && [ ! -z "$NEXUS_PASSWORD" ]; then
  echo -e "${BLUE}Logging in to Nexus registry...${NC}"
  echo "$NEXUS_PASSWORD" | docker login ${NEXUS_REGISTRY} -u $NEXUS_USERNAME --password-stdin
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to login to Nexus registry${NC}"
    exit 1
  fi
else
  echo -e "${YELLOW}Warning: No registry credentials provided. Assuming you're already logged in.${NC}"
fi

# =====================================================
# Build and Push Process
# =====================================================

# Set working directory to project root
cd "$(dirname "$0")"

# Use BuildKit for improved build performance
export DOCKER_BUILDKIT=1

echo -e "${BLUE}Starting build process...${NC}"

# Build and push frontend image with proper cache handling
echo -e "${BLUE}Building frontend image...${NC}"
docker build \
  --cache-from ${NEXUS_REGISTRY}/intric/frontend:latest \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  -t ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG} \
  ./frontend

if [ $? -ne 0 ]; then
  echo -e "${RED}Error: Failed to build frontend image${NC}"
  exit 1
fi

echo -e "${GREEN}Frontend image built successfully${NC}"
echo -e "${BLUE}Pushing frontend image to Nexus...${NC}"

docker push ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG}
if [ $? -ne 0 ]; then
  echo -e "${RED}Error: Failed to push frontend image${NC}"
  exit 1
fi
echo -e "${GREEN}Frontend image pushed successfully${NC}"

# Build and push backend image with proper cache handling
echo -e "${BLUE}Building backend image...${NC}"
docker build \
  --cache-from ${NEXUS_REGISTRY}/intric/backend:latest \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  -t ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG} \
  ./backend

if [ $? -ne 0 ]; then
  echo -e "${RED}Error: Failed to build backend image${NC}"
  exit 1
fi

echo -e "${GREEN}Backend image built successfully${NC}"
echo -e "${BLUE}Pushing backend image to Nexus...${NC}"

docker push ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG}
if [ $? -ne 0 ]; then
  echo -e "${RED}Error: Failed to push backend image${NC}"
  exit 1
fi
echo -e "${GREEN}Backend image pushed successfully${NC}"

# Tag as latest if not already tagged as such but only for main/master branch
# or if it's a semantic version
if [ "$IMAGE_TAG" != "latest" ]; then
  if [[ "$IMAGE_TAG" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
    echo -e "${BLUE}Tagging images as latest...${NC}"
    docker tag ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG} ${NEXUS_REGISTRY}/intric/frontend:latest
    docker tag ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG} ${NEXUS_REGISTRY}/intric/backend:latest
    
    echo -e "${BLUE}Pushing latest tags to Nexus...${NC}"
    docker push ${NEXUS_REGISTRY}/intric/frontend:latest
    docker push ${NEXUS_REGISTRY}/intric/backend:latest
    echo -e "${GREEN}Latest tags pushed successfully${NC}"
  else
    echo -e "${YELLOW}Skipping latest tag push for development branch${NC}"
  fi
fi

# =====================================================
# Summary
# =====================================================

echo -e "${GREEN}Build and push complete! Images are now available in the Nexus registry.${NC}"
echo -e "${GREEN}Frontend: ${NEXUS_REGISTRY}/intric/frontend:${IMAGE_TAG}${NC}"
echo -e "${GREEN}Backend: ${NEXUS_REGISTRY}/intric/backend:${IMAGE_TAG}${NC}"
echo ""
echo -e "${BLUE}To deploy in production:${NC}"
echo "1. Set NEXUS_REGISTRY and IMAGE_TAG environment variables on the production server"
echo "2. Run: docker compose pull"
echo "3. Run: docker compose up -d"
echo "4. First time only: docker compose --profile init up db-init"