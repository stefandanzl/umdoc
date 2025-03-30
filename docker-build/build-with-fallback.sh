#!/bin/bash

# Create the necessary directories
mkdir -p output

echo "Attempting to build both Linux and Windows executables..."
if command -v docker-compose &> /dev/null; then
    mkdir -p cmake
    if [ -f "mingw-w64-x86_64.cmake" ]; then
        cp mingw-w64-x86_64.cmake cmake/
        docker-compose up --build
    else
        echo "mingw-w64-x86_64.cmake not found, skipping full build."
    fi
else
    echo "docker-compose not found, skipping full build."
fi

echo "Building Linux-only version..."
docker build -f Dockerfile.linux -t umdoc-builder-linux .

echo "Extracting executable from container..."
docker run --rm -v "$(pwd)/output:/output" umdoc-builder-linux bash -c "find /build -name umdoc -type f -not -path '*/\.*' | xargs -I{} cp {} /output/umdoc-linux && chmod +x /output/umdoc-linux && echo 'Linux executable copied to output directory.'"

echo "Build process completed. Check if executable exists:"
if [ -f "output/umdoc-linux" ]; then
    echo "Success! Executable found."
    ls -la output/umdoc-linux
else
    echo "Error: Executable not found. Let's look deeper into the container:"
    docker run --rm umdoc-builder-linux bash -c "find /build -name umdoc -type f | grep -v '/\.' && echo '---' && ls -la /build/umdoc/build-linux/"
fi
