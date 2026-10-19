#!/bin/sh
# Rebuild Ubuntu's NAM without its broken pre-initialization stub calls.
# See Debian bug #820101.
set -eu
mkdir -p /tmp/nam-build
cd /tmp/nam-build
apt-get source nam
cd nam-1.15
sed -i '/Tcl_InitStubs(interp, "8.1", 0);/d; /Tk_InitStubs(interp, "8.1", 0);/d' main.cc
cp debian/CMakeLists.txt debian/config-nam.h.cmake .
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j2
install -m 755 nam /usr/local/bin/nam
