#!/bin/bash
DT=${DT:-$(date +'%m%d')}
NP=${NP:-$(nproc)}
PRE=${PRE:-}
SUF=${SUF:-}
RE=${RE:-}

# for config
SRC_DIR=../../"${PRE}src${SUF}"
BUILD_DIR=$(pwd)
INSTALL_PREFIX=$(realpath $BUILD_DIR/../../install/)
INSTALL_DIR="$INSTALL_PREFIX"/"$RE"$(basename "$BUILD_DIR")-$DT

case $1 in
vr)
  set -x
  $SRC_DIR/configure --prefix=$INSTALL_DIR --enable-shared --enable-checking=yes,extra --with-system-zlib --enable-__cxa_atexit --enable-linker-build-id --enable-plugin --with-isl --enable-lto --disable-nls --disable-bootstrap --disable-multilib --enable-languages=c,c++,fortran
  ;;
c0 | cf0 | config0) # default conf
  set -x
  $SRC_DIR/configure --prefix=$INSTALL_DIR
  exit 0
  ;;
c | cf | config) # build fast
  set -x
  $SRC_DIR/configure --prefix=$INSTALL_DIR --disable-multilib --disable-bootstrap --enable-languages=c,c++,fortran --enable-checking=yes,extra
  exit 0
  ;;
cc) # build fast
  set -x
  $SRC_DIR/configure --prefix=$INSTALL_DIR --disable-multilib --disable-bootstrap --enable-languages=c,c++,fortran
  exit 0
  ;;
ccx)
  set -x
  $SRC_DIR/configure --with-bugurl=https://github.com/AmpereComputing/ampere-gcc/issues --prefix=$INSTALL_DIR --disable-bootstrap --disable-multilib --with-pkgversion=GCC
  exit 0
  ;;
c1 | cf1 | config1) # build go
  set -x
  $SRC_DIR/configure --prefix=$INSTALL_DIR --disable-multilib --disable-bootstrap --enable-languages=c,c++,fortran,go --enable-checking=release
  exit 0
  ;;
test)
  make -j$NP
  make -k check -j $NP RUNTESTFLAGS="-v" 2>&1 | tee make_check.log
  ;;
b0 | build-g0)
  set -e
  set -x
  make -j$NP CFLAGS="-g3 -O0" CXXFLAGS="-g3 -O0"
  make install -j$NP
  ;;
b | build)
  set -e
  set -x
  make -j$NP
  make install -j$NP
  ;;
bs | build-scratch)
  set -e
  set -x
  make -j$NP
  make install -j$NP
  ;;
check)
  make -k check -j $NP
  ;;
half-check)
  make -j $(($(nproc) / 2))
  make -k check -j $(($(nproc) / 2)) RUNTESTFLAGS="-v" 2>&1 | tee make_check.log
  ;;
esac
