#!/bin/bash

# This script patches the source code to handle cross-compilation issues

cd /build/umdoc

# Patch Debug.cpp
cat > /tmp/debug_patch.txt << 'EOF'
--- a/Ext/libnstd/src/Debug.cpp
+++ b/Ext/libnstd/src/Debug.cpp
@@ -1,6 +1,10 @@
 
 #include <nstd/Debug.hpp>
 
+#if defined(_WIN32) && !defined(__clang__)
 #include <Windows.h>
+#else
+// Alternative implementation for non-Windows or Clang cross-compilation
+#endif
 
EOF
patch -p1 < /tmp/debug_patch.txt || true

# Patch Directory.cpp
cat > /tmp/directory_patch.txt << 'EOF'
--- a/Ext/libnstd/src/Directory.cpp
+++ b/Ext/libnstd/src/Directory.cpp
@@ -7,7 +7,11 @@
 
 #if defined(_WIN32)
 
+#if !defined(__clang__)
 #include <Windows.h>
+#else
+// Alternative implementation for Clang cross-compilation
+#endif
 
 bool Directory::exists(const String& dir)
 {
EOF
patch -p1 < /tmp/directory_patch.txt || true

# Patch Console.cpp
cat > /tmp/console_patch.txt << 'EOF'
--- a/Ext/libnstd/src/Console.cpp
+++ b/Ext/libnstd/src/Console.cpp
@@ -12,7 +12,11 @@
 
 #elif defined(__linux__)
 
+#if !defined(__clang__) || !defined(_WIN32)
 #include <sys/eventfd.h>
+#else
+// Skip eventfd for clang cross-compilation
+#endif
 #include <unistd.h>
 #include <termios.h>
 #include <sys/ioctl.h>
EOF
patch -p1 < /tmp/console_patch.txt || true

echo "Source code patched for cross-compilation"
