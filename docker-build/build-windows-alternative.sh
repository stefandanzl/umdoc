#!/bin/bash

# This script builds Windows executable using an alternative approach with MXE

# Create output directory
mkdir -p output

echo "Building Windows executable using MXE (MinGW Cross Environment)"
echo "This approach is more comprehensive but will take longer to build"
echo "=============================================================="

# Build the Docker image
docker build -f Dockerfile.windows-mingw -t umdoc-builder-mxe .

# Run the container to copy the executable
docker run --rm -v "$(pwd)/output:/output" umdoc-builder-mxe bash -c "if [ -f /output/windows/umdoc.exe ]; then cp /output/windows/umdoc.exe /output/umdoc-windows.exe; echo 'Windows executable copied to output directory.'; else echo 'No Windows executable was built.'; fi"

# Check if the executable was created
if [ -f "output/umdoc-windows.exe" ]; then
    echo "=============================================================="
    echo "Build successful! Windows executable is at: output/umdoc-windows.exe"
    ls -la output/umdoc-windows.exe
else
    echo "=============================================================="
    echo "Error: Windows build failed"
fi
