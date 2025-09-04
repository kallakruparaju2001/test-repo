#!/bin/bash
set -e

# Mandatory parameters
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$ENV" ] || [ -z "$TAG" ]; then
  echo "Usage: USERNAME=<dockerhub-user> PASSWORD=<dockerhub-pass> ENV=<env> TAG=<tag> ./build_and_push.sh"
  exit 1
fi

# Docker Hub Login
echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin

# Build the image
USERNAME=$USERNAME ENV=$ENV TAG=$TAG docker-compose -f docker-compose.build.yml build

# Push the image
USERNAME=$USERNAME ENV=$ENV TAG=$TAG docker-compose -f docker-compose.build.yml push

echo "Build & Push completed: $USERNAME/react-app:$ENV-$TAG"
