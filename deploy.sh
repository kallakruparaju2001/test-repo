#!/bin/bash
set -e

# Mandatory parameters
if [ -z "$USERNAME" ] || [ -z "$ENV" ] || [ -z "$TAG" ]; then
  echo "Usage: USERNAME=<dockerhub-user> ENV=<env> TAG=<tag> ./deploy.sh"
  exit 1
fi

USERNAME=$USERNAME ENV=$ENV TAG=$TAG docker-compose -f docker-compose.deploy.yml up -d

echo "Deployment completed: $USERNAME/react-app:$ENV-$TAG is running"
