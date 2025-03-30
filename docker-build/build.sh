#!/bin/bash

# Create the necessary directories
mkdir -p output cmake

# Copy the MinGW toolchain file
cp mingw-w64-x86_64.cmake cmake/

# Build and run with Docker Compose
docker-compose up --build

echo "Build completed. Executables are in the 'output' directory."
echo "  - Linux executable: output/umdoc-linux"
echo "  - Windows executable: output/umdoc-windows.exe"