#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <container_name> <service_name> <target_image_name>"
  exit 1
fi

container_name=$1
service_name=$2
target_image_name=$3


# Function to check if image has changed
function image_changed() {
  local image_id=$(docker inspect --format="{{ .Image }}" "$container_name")
  local image_latest=$(docker image inspect --format="{{ .Id }}" "$target_image_name" | head -n 1)
  echo "$(date +%Y-%m-%d_%H-%M-%S) - Service: $service_name - Current Image Hash: $image_id - New Image Hash: $image_latest"
  if [[ "$image_id" != "$image_latest" ]]; then
    return 0
  fi
  return 1
}

# Pull the Nginx image
docker-compose pull "$service_name"

# Check if image has changed and restart if necessary
if image_changed; then
  echo "$(date +%Y-%m-%d_%H-%M-%S) - image changed, performing docker-compose up -d $service_name"
  docker-compose up -d "$service_name"
fi