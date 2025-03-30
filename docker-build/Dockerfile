FROM ubuntu:22.04

# Set noninteractive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic build tools and dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    g++ \
    mingw-w64 \
    clang \
    lld \
    llvm \
    msitools \
    wine64 \
    wine64-tools \
    wine64-preloader \
    texlive-xetex \
    texlive-fonts-extra \
    curl \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /build

# Copy the MinGW toolchain file
COPY cmake/mingw-w64-x86_64.cmake /build/cmake/mingw-w64-x86_64.cmake

# Clone the umdoc repository
RUN git clone https://github.com/craflin/umdoc.git && \
    cd umdoc && \
    git submodule update --init

# Copy and apply patches for cross-compilation
COPY crossbuild-patch.sh /build/
RUN chmod +x /build/crossbuild-patch.sh && \
    /build/crossbuild-patch.sh

# Build for Linux
RUN mkdir -p /build/umdoc/build-linux && \
    cd /build/umdoc/build-linux && \
    cmake .. && \
    make -j$(nproc)

# Build for Windows
RUN mkdir -p /build/umdoc/build-windows && \
    cd /build/umdoc/build-windows && \
    mkdir -p ../cmake && \
    cp /build/cmake/mingw-w64-x86_64.cmake ../cmake/ && \
    cmake .. -DCMAKE_TOOLCHAIN_FILE=../cmake/mingw-w64-x86_64.cmake && \
    make -j$(nproc)

# Create output directory for binaries
RUN mkdir -p /output

# Set volume for getting binaries out
VOLUME /output

# Default command
CMD ["bash"]