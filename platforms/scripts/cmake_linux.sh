#!/bin/sh
cd `dirname $0`/..

mkdir -p build_linux
cd build_linux

cmake CMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local $@ ../..
