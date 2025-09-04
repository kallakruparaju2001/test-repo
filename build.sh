#!/usr/bin/env bash
set -euo pipefail
IMAGE="react-app"
TAG="latest"


echo "[+] Building $IMAGE:$TAG"
docker build -t "$IMAGE:$TAG" .
echo "[✓] Built $IMAGE:$TAG
