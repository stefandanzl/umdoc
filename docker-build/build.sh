#!/bin/bash

# Check if we have all required tools
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Create the necessary directories
mkdir -p output

# Check if docker-compose is available
if command -v docker-compose &> /dev/null; then
    echo "Using docker-compose for build..."
    
    # Check if MinGW toolchain file exists
    if [ -f "mingw-w64-x86_64.cmake" ]; then
        mkdir -p cmake
        cp mingw-w64-x86_64.cmake cmake/
        docker-compose up --build
    else
        echo "Warning: mingw-w64-x86_64.cmake not found, Windows build will fail."
        echo "Proceeding with Linux-only build..."
        ./simple-linux-build.sh
    fi
else
    echo "docker-compose not available, using simple Linux build..."
    ./simple-linux-build.sh
fi

# Verify executables were created
echo "Checking build results:"
if [ -f "output/umdoc-linux" ]; then
    echo "  - Linux executable: output/umdoc-linux ✓"
else
    echo "  - Linux executable: MISSING ✗"
fi

if [ -f "output/umdoc-windows.exe" ]; then
    echo "  - Windows executable: output/umdoc-windows.exe ✓"
else
    echo "  - Windows executable: MISSING ✗"
fi