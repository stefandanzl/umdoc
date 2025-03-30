#!/bin/bash

# Create the necessary directories
mkdir -p output cmake
cp mingw-w64-x86_64.cmake cmake/

echo "Attempting to build both Linux and Windows executables..."
if docker-compose up --build; then
    echo "Build completed successfully."
else
    echo "Full build failed. Falling back to Linux-only build..."
    docker build -f Dockerfile.linux -t umdoc-builder-linux .
    docker run --rm -v "$(pwd)/output:/output" umdoc-builder-linux bash -c "cp /build/umdoc/build-linux/umdoc /output/umdoc-linux && echo 'Linux executable copied to output directory.'"
    echo "Linux-only build completed."
fi

echo "Check the 'output' directory for the built executables."
