#!/bin/bash

NCPU=${NCPU:-$(nproc)}
DT=$(date +'%m%d')

PROJ_DIR=$(cd $(dirname $0) && pwd)
BUILD_DIR="$PROJ_DIR"/build
INSTALL_DIR="$PROJ_DIR"/install
mkdir -p $INSTLAL_DIR
if [[ -n $DBG ]]; then
  BUILD_DIR="$BUILD_DIR".dbg
  INSTALL_DIR="$INSTALL_DIR".dbg
  BUILD_TYPE=Debug
else
  BUILD_DIR="$BUILD_DIR".rel
  INSTALL_DIR="$INSTALL_DIR".rel
  BUILD_TYPE=Release
fi

mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

case $1 in
pre)
  sudo apt-get install lld
  sudo apt-get install clang
  ;;
c1)
  cmake -G Ninja "$PROJ_DIR"/llvm-project/llvm \
    -DLLVM_ENABLE_LLD=ON \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DLLVM_TARGETS_TO_BUILD="AArch64" \
    -DLLVM_ENABLE_PROJECTS="clang;llvm" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
  ;;
cr | conf-rel)
  cmake -G Ninja "$PROJ_DIR"/llvm-project/llvm \
    -DLLVM_ENABLE_LLD=ON \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64" \
    -DLLVM_ENABLE_PROJECTS="clang;llvm" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
  ;;
c0 | conf-dbg)
  set -x
  cmake -G Ninja "$PROJ_DIR"/llvm-project/llvm \
    -DLLVM_ENABLE_LLD=ON \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64" \
    -DLLVM_ENABLE_PROJECTS="clang;llvm" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
  ;;
mlir)
  cmake -G Ninja "$PROJ_DIR"/llvm-project/llvm \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DLLVM_ENABLE_ASSERTIONS=ON
  # Using clang and lld speeds up the build, we recommend adding:
  #  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON
  # CCache can drastically speed up further rebuilds, try adding:
  #  -DLLVM_CCACHE_BUILD=ON
  # Optionally, using ASAN/UBSAN can find bugs early in development, enable with:
  # -DLLVM_USE_SANITIZER="Address;Undefined"
  # Optionally, enabling integration tests as well
  # -DMLIR_INCLUDE_INTEGRATION_TESTS=ON
  cmake --build . --target check-mlir
  ;;
omp)
  cmake -G Ninja "$PROJ_DIR"/llvm-project/llvm \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64;NVPTX" \
    -DLLVM_ENABLE_PROJECTS="clang;llvm" \
    -DLLVM_ENABLE_RUNTIMES="openmp;offload" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
  ;;
hip)
  cmake -G Ninja "$PROJ_DIR"/llvm-project/llvm \
    -DLLVM_BUILD_EXAMPLES=OFF \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64;NVPTX;AMDGPU" \
    -DLLVM_ENABLE_PROJECTS="clang;llvm;lld" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DLLVM_ENABLE_ASSERTIONS=OFF \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
  ;;
ai)
  cmake -G Ninja "$PROJ_DIR"/llvm-project/llvm \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64;NVPTX;AMDGPU" \
    -DLLVM_ENABLE_PROJECTS="clang;llvm;lld;mlir" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
  ;;
b)
  set -x
  ninja -j"$NCPU"
  ninja install
  ;;
esac
