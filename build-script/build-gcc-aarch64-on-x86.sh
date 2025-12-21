#!/bin/sh

# Pre-requisites
# sudo apt-get install autoconf make automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

export TARGET=aarch64-linux
export WORKSPACE="$HOME/gcc/aarch64"

SRC_DIR="$WORKSPACE/src"
BUILD_DIR="$WORKSPACE/build/$PRE$(date +'%m%d')"
INSTALL_DIR="$WORKSPACE/install/$PRE$(date +'%m%d')"

NP=${NP:-$(nproc)}
export PATH="$INSTALL_DIR/bin:$PATH"
mkdir -p $SRC_DIR $BUILD_DIR $INSTALL_DIR

prepare_src() {
  cd $SRC_DIR
  BINUTILS=binutils-2.35.tar.gz
  GLIBC=glibc-2.32.tar.gz
  LINUX=linux-5.4.tar.gz

  # binutils, glibc, linux headers
  [ ! -f ${BINUTILS}.tar.gz ] && wget https://ftp.gnu.org/gnu/binutils/${BINUTILS}.tar.gz
  [ ! -f ${GLIBC}.tar.gz ] && wget https://mirrors.kernel.org/gnu/glibc/${GLIBC}.tar.gz
  [ ! -f ${LINUX}.tar.gz ] && wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/${LINUX}.tar.gz

  [ ! -d $BINUTILS ] && tar -xf ./binutils-2.35.tar.gz
  [ ! -d $GLIBC ] && tar -xf ./glibc-2.32.tar.gz
  [ ! -d $LINUX ] && tar -xf ./linux-5.4.tar.gz

  # gcc
  [ ! -d gcc ] && git clone git://gcc.gnu.org/git/gcc.git

  cd gcc
  git checkout releases/gcc-10.2.0
  ./contrib/download_prerequisites
}

# start building
build_binutils () {
  mkdir -p ${BUILD_DIR}/build-binutils
  cd ${BUILD_DIR}/build-binutils
  $SRC_DIR/binutils-2.35/configure --target=$TARGET --prefix=$INSTALL_DIR --with-sysroot --disable-multilib
  make -j$NP
  make install
}
install_linux_headers () {
  cd $SRC_DIR/linux-5.4
  make ARCH=arm64 INSTALL_HDR_PATH=$INSTALL_DIR/$TARGET headers_install
}
build_gcc_1 () {
  mkdir -p ${BUILD_DIR}/build-gcc
  cd ${BUILD_DIR}/build-gcc
  if [ $DEBUG = 'y' ]; then
    $SRC_DIR/gcc/configure --prefix=$INSTALL_DIR --target=$TARGET --enable-languages=c,c++ --disable-multilib --disable-libsanitizer CFLAGS="-g3 -O0" CXXFLAGS="-g3 -O0"
  else
    $SRC_DIR/gcc/configure --prefix=$INSTALL_DIR --target=$TARGET --enable-languages=c,c++ --disable-multilib --disable-libsanitizer
  fi
  make -j$NP all-gcc
  make install-gcc
}
build_glibc_1 () {
  mkdir -p ${BUILD_DIR}/build-glibc
  cd ${BUILD_DIR}/build-glibc
  $SRC_DIR/glibc-2.32/configure --prefix=$INSTALL_DIR/$TARGET --build=$MACHTYPE --host=${TARGET} --target=${TARGET} --with-headers=$INSTALL_DIR/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
  make install-bootstrap-headers=yes install-headers # --without-selinux # if problem with selinux/selinux.h
  make -j$NP csu/subdir_lib
  install csu/crt1.o csu/crti.o csu/crtn.o $INSTALL_DIR/$TARGET/lib
  ${TARGET}-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $INSTALL_DIR/$TARGET/lib/libc.so
  touch $INSTALL_DIR/$TARGET/include/gnu/stubs.h
}
build_gcc_2 () {
  cd ${BUILD_DIR}/build-gcc
  make -j$NP all-target-libgcc
  make install-target-libgcc
}
build_glibc_2 () {
  cd ${BUILD_DIR}/build-glibc
  make -j$NP
  make install
}
build_gcc_3 () {
  cd ${BUILD_DIR}/build-gcc
  make -j$NP
  make install
  $INSTALL_DIR/bin/aarch64-linux-gcc -v
}

DEBUG=n
case $1 in
    src | prepare)
      prepare_src  
      return 0 ;;
    b0 )
      export DEBUG=y
      ;;
esac

build_binutils
install_linux_headers
build_gcc_1
build_glibc_1
build_gcc_2
build_glibc_2
build_gcc_3
