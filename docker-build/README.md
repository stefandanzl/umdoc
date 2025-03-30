# umdoc Docker Builder

This Docker setup allows you to build umdoc executables for both Linux and Windows without needing to install all the C++ dependencies directly on your system.

## Prerequisites

- Docker installed on your machine
- Docker Compose installed on your machine
- Bash shell (for running the build script)

## File Structure

- `Dockerfile`: Sets up the build environment with all necessary dependencies
- `docker-compose.yml`: Configures the Docker Compose build process
- `mingw-w64-x86_64.cmake`: Toolchain file for cross-compiling to Windows
- `build.sh`: Script to build the Docker image and run the container

## Usage

### Option 1: Using the build script

1. Create a directory for your build:

```bash
mkdir umdoc-docker-build
cd umdoc-docker-build
```

2. Copy all files from this repository into that directory:
   - `Dockerfile`
   - `docker-compose.yml`
   - `mingw-w64-x86_64.cmake`
   - `build.sh`

3. Make the build script executable:

```bash
chmod +x build.sh
```

4. Run the build script:

```bash
./build.sh
```

5. After the build completes, you'll find the executables in the `output` directory:
   - `umdoc-linux`: Linux executable
   - `umdoc-windows.exe`: Windows executable

### Option 2: Using Docker Compose directly

If you prefer to use Docker Compose commands directly:

1. Set up the directory structure:

```bash
mkdir -p output cmake
cp mingw-w64-x86_64.cmake cmake/
```

2. Run Docker Compose:

```bash
docker-compose up --build
```

3. After the build completes, the executables will be in the `output` directory.

### Advanced Docker Compose Options

The Docker Compose configuration provides several specialized services you can use:

#### Build only Linux executable:

```bash
docker-compose --profile linux-only up linux-builder
```

#### Build only Windows executable:

```bash
docker-compose --profile windows-only up windows-builder
```

#### Interactive debugging shell:

If you need to debug the build environment or make manual adjustments:

```bash
docker-compose --profile debug up shell
```

This will give you an interactive shell inside the container where you can examine the build environment.

### Option 3: Using Make

For users who prefer using make, a Makefile is provided with common operations:

```bash
# Build both Linux and Windows executables
make

# Build only the Linux executable (requires Docker Compose)
make linux

# Build only the Linux executable without using Docker Compose (fallback option)
make linux-only

# Build only the Windows executable
make windows

# Get an interactive shell
make shell

# Clean up build artifacts
make clean
```

## Notes

- The build process may take some time, especially the first time as it needs to download the Ubuntu image and install all dependencies.
- The Windows executable is built using MinGW-w64 and should work on Windows 7/8/10/11.
- If you need to make changes to the build process, modify the `Dockerfile` as needed.

## Troubleshooting

- If you get permission errors when running the executables on Linux, use `chmod +x output/umdoc-linux` to make it executable.
- For Windows, you may need to install any required DLLs if they're not already on your system.