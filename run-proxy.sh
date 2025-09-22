#!/bin/bash

# Simple Proxy Docker Runner Script
# Usage: ./run-proxy.sh [options]

set -e

DOCKER_IMAGE="simple-proxy:v1.0.0"
CONTAINER_NAME="simple-proxy"
DEFAULT_PORT="8888"
DEFAULT_AUTH=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--port)
      PROXY_PORT="$2"
      shift 2
      ;;
    -a|--auth)
      BASIC_AUTH="$2"
      shift 2
      ;;
    --build)
      BUILD_IMAGE=true
      shift
      ;;
    --stop)
      echo "Stopping and removing existing container..."
      docker stop $CONTAINER_NAME 2>/dev/null || true
      docker rm $CONTAINER_NAME 2>/dev/null || true
      echo "Container stopped and removed."
      exit 0
      ;;
    --logs)
      echo "Showing logs for $CONTAINER_NAME..."
      docker logs -f $CONTAINER_NAME
      exit 0
      ;;
    -h|--help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  -p, --port PORT     Set proxy port (default: $DEFAULT_PORT)"
      echo "  -a, --auth USER:PASS Set basic authentication"
      echo "  --build             Build Docker image before running"
      echo "  --stop              Stop and remove container"
      echo "  --logs              Show container logs"
      echo "  -h, --help          Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0 -p 3128 -a admin:password"
      echo "  $0 --build -p 8080"
      echo "  $0 --stop"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

# Set defaults
PROXY_PORT=${PROXY_PORT:-$DEFAULT_PORT}

# Build image if requested
if [[ "$BUILD_IMAGE" == "true" ]]; then
  echo "Building Docker image..."
  docker build -t $DOCKER_IMAGE .
fi

# Stop existing container
echo "Stopping existing container (if any)..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Prepare command arguments
CMD_ARGS=("-port" "$PROXY_PORT" "-bind" "0.0.0.0")

if [[ -n "$BASIC_AUTH" ]]; then
  CMD_ARGS+=("-basic-auth" "$BASIC_AUTH")
  echo "Starting proxy with authentication on port $PROXY_PORT..."
else
  echo "Starting proxy without authentication on port $PROXY_PORT..."
fi

# Run container
docker run -d \
  --name $CONTAINER_NAME \
  -p "$PROXY_PORT:$PROXY_PORT" \
  $DOCKER_IMAGE \
  "${CMD_ARGS[@]}"

echo "✅ Proxy started successfully!"
echo "📍 Proxy URL: http://localhost:$PROXY_PORT"
if [[ -n "$BASIC_AUTH" ]]; then
  echo "🔐 Authentication: $BASIC_AUTH"
fi
echo ""
echo "Commands:"
echo "  View logs: $0 --logs"
echo "  Stop proxy: $0 --stop"