#!/bin/bash

VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-all}"
REPO_ROOT="$(git rev-parse --show-toplevel)"

pushd "$REPO_ROOT" > /dev/null 2>&1

docker pull nvcr.io/nvidia/tritonserver:21.02-py3
docker build -t triton_dev -f ops/Dockerfile .

docker run \
  --rm \
  --gpus "device=${VISIBLE_DEVICES}" \
  --name triton_dev \
  -it \
  -v "${REPO_ROOT}:/identity_backend" \
  -v triton-ccache:/root/.ccache \
  -v triton-build:/identity_backend/build \
  triton_dev

popd > /dev/null 2>&1
