# export ROCM_BRANCH=rocm-6.1.x
export ROCM_BRANCH=release/rocm-rel-6.4
PROG_DIR=$(cd $(dirname $0) && pwd)

# mkdir -p src; cd src
# git clone -b "$ROCM_BRANCH" https://github.com/ROCm/clr.git
# git clone -b "$ROCM_BRANCH" https://github.com/ROCm/hip.git
# git clone -b "$ROCM_BRANCH" https://github.com/ROCm/hipother.git
# git clone -b ${ROCM_BRANCH} https://github.com/ROCm/HIPNV.git src/hipnv
# git clone -b ${ROCM_BRANCH} https://github.com/ROCm/ROCR-Runtime.git

. $HOME/.pyvenv/bin/activate
export CLR_DIR="$(readlink -f src/clr)"
export HIP_DIR="$(readlink -f src/hip)"
export ROCR_DIR="$(readlink -f src/ROCR-Runtime)"
export HIPNV_DIR="$(readlink -f src/hipother/hipnv)"

# cd "$CLR_DIR"
# rm -rf build install
rm -rf build
mkdir -p build
cd build

case $1 in
nv)
  cmake -DHIP_COMMON_DIR=$HIP_DIR -DHIP_PLATFORM=nvidia -DHIPNV_DIR=$HIPNV_DIR -DCMAKE_PREFIX_PATH="/usr/local/cuda" -DCMAKE_INSTALL_PREFIX=$PROG_DIR/install -DHIP_CATCH_TEST=0 -DCLR_BUILD_HIP=ON -DCLR_BUILD_OCL=OFF $CLR_DIR
  ;;
clr)
  cmake -DHIP_COMMON_DIR=$HIP_DIR -DHIP_PLATFORM=amd -DCMAKE_PREFIX_PATH="/opt/rocm/" -DHIPCC_BIN_DIR="/opt/rocm/bin/" -DCMAKE_INSTALL_PREFIX=$PROG_DIR/install -DHIP_CATCH_TEST=0 -DCLR_BUILD_HIP=ON -DCLR_BUILD_OCL=OFF $CLR_DIR
  ;;
hsa)
  export PATH=$li/may7-hip-cuda-lld-0507/bin:$PATH
  cmake -DCMAKE_INSTALL_PREFIX=$PROG_DIR/install -DCMAKE_PREFIX_PATH="/opt/rocm;/home/hliu/hliu/202-llvm/install/may7-hip-cuda-lld-0507;" -DROCM_DIR="/opt/rocm" $ROCR_DIR
  # oneTBB
  ;;
esac

make -j$(nproc)
make install
