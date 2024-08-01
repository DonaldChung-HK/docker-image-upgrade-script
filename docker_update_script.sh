#!/bin/bash

update_docker_service() {
    local image_name=$1
    local service_name=$2
    local is_pruning=$3
    # Pull the latest image
    echo "Pulling the latest $image_name image..."
    docker pull $image_name

    # Check if the image was updated
    IMAGE_UPDATED=$(docker images --filter=reference="$image_name" --format "{{.ID}}" | head -n 1)

    # Get the current running container ID for the service
    CURRENT_CONTAINER_ID=$(docker ps --filter="name=$container_name" --format "{{.ID}}")

    if [ -n "$CURRENT_CONTAINER_ID" ]; then
        echo "Current running container ID: $CURRENT_CONTAINER_ID"
    else
        echo "No running container found for $image_name"
    fi

    # Run docker-compose up for the service
    echo "Running docker-compose up for the $service_name service..."
    docker-compose up -d $service_name

    # Get the new running container ID for the service
    NEW_CONTAINER_ID=$(docker ps --filter="name=$container_name" --format "{{.ID}}" | head -n 1)

    if [ "$CURRENT_CONTAINER_ID" != "$NEW_CONTAINER_ID" ]; then
        echo "New container ID: $NEW_CONTAINER_ID"
        if [ "$is_prunning" = "true" ]; then
            echo "Cleaning up the old images that is more than 10 days old..."
            docker image prune -a --force --filter "until=240h"
        fi
        
    else
        echo "No new container was created. The image might not have been updated."
    fi

    echo "Script execution completed."
}

# Example usage:
update_docker_service "$1" "$2" "$3"