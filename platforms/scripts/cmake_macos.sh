#!/bin/sh
cd `dirname $0`/..

mkdir -p build_macos
cd build_macos

cmake CMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local $@ ../..
