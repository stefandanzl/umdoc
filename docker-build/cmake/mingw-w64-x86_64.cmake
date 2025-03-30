# Toolchain file for Windows cross-compilation using Clang
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Use Clang as the compiler
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_LINKER lld)

# Set compilation flags for Windows
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --target=x86_64-w64-mingw32 -D_WIN32 -D_WIN32_WINNT=0x0601")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --target=x86_64-w64-mingw32 -D_WIN32 -D_WIN32_WINNT=0x0601")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --target=x86_64-w64-mingw32")

# Where to find the target environment
set(CMAKE_FIND_ROOT_PATH /usr/x86_64-w64-mingw32)

# Add include directories (both MinGW and standard system)
include_directories(
    /usr/x86_64-w64-mingw32/include
    /usr/include/x86_64-w64-mingw32
    /usr/include
)

# Adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)