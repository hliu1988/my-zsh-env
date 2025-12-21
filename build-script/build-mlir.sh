#!/bin/bash

NCPU=${NCPU:-$(nproc)}
DT=$(date +'%m%d')

BUILD_DIR=$(pwd)
mkdir -p ../../install/
PREFIX=$(realpath ../../install/$(basename "$BUILD_DIR")-$DT)

# export PATH=$w202/install/last/bin:$PATH
clang -v

case $1 in
c0 | conf0)
  set -x
  cmake -G Ninja ../../llvm-project/llvm \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
    -DCMAKE_BUILD_TYPE=Debug -DLLVM_USE_SPLIT_DWARF=ON -DLLVM_ENABLE_LLD=ON \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_INSTALL_PREFIX=$PREFIX
  ;;
c | conf)
  set -x
  cmake -G Ninja ../../llvm-project/llvm \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
    -DCMAKE_BUILD_TYPE=Debug -DLLVM_USE_SPLIT_DWARF=ON \
    -DLLVM_ENABLE_ASSERTIONS=ON\
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON \
    -DLLVM_CCACHE_BUILD=OFF \
    -DCMAKE_INSTALL_PREFIX=$PREFIX
  ;;
b | build)
  cmake --build . --target check-mlir
;;
esac
