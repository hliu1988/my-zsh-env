#!/bin/sh

# Pre-requisites
# sudo apt-get install autoconf make automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

export TARGET=aarch64-linux
export WORKSPACE="$(pwd)"

SRC_DIR="$WORKSPACE/src"
BUILD_DIR="$WORKSPACE/build/$PRE$(date +'%m%d')"
INSTALL_DIR="$WORKSPACE/install/$PRE$(date +'%m%d')"

NP=${NP:-$(nproc)}
export PATH="$INSTALL_DIR/bin:$PATH"
mkdir -p $SRC_DIR $BUILD_DIR $INSTALL_DIR

set -x

depend_src() {
    cd $SRC_DIR
    BINUTILS=binutils-2.40
    GLIBC=glibc-2.38
    LINUX=linux-6.2.16

    # binutils, glibc, linux headers
    [ ! -f ${BINUTILS}.tar.gz ] && wget https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.gz
    [ ! -f ${GLIBC}.tar.gz ] && wget https://mirrors.kernel.org/gnu/glibc/glibc-2.38.tar.gz
    [ ! -f ${LINUX}.tar.xz ] && wget https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-6.2.16.tar.xz

    [ ! -d $BINUTILS ] && tar -xf ${BINUTILS}.tar.gz
    [ ! -d $GLIBC ] && tar -xf ${GLIBC}.tar.gz
    [ ! -d $LINUX ] && tar -xf ${LINUX}.tar.xz
}

# start building
build_binutils() {
    mkdir -p ${BUILD_DIR}/build-binutils
    cd ${BUILD_DIR}/build-binutils
    $SRC_DIR/binutils-2.35/configure --target=$TARGET --prefix=$INSTALL_DIR --with-sysroot --disable-multilib
    make -j$NP
    make install
}
install_linux_headers() {
    cd $SRC_DIR/linux-5.4
    make ARCH=arm64 INSTALL_HDR_PATH=$INSTALL_DIR/$TARGET headers_install
}
build_gcc_1() {
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
build_glibc_1() {
    mkdir -p ${BUILD_DIR}/build-glibc
    cd ${BUILD_DIR}/build-glibc
    $SRC_DIR/glibc-2.32/configure --prefix=$INSTALL_DIR/$TARGET --build=$MACHTYPE --host=${TARGET} --target=${TARGET} --with-headers=$INSTALL_DIR/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
    make install-bootstrap-headers=yes install-headers # --without-selinux # if problem with selinux/selinux.h
    make -j$NP csu/subdir_lib
    install csu/crt1.o csu/crti.o csu/crtn.o $INSTALL_DIR/$TARGET/lib
    ${TARGET}-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $INSTALL_DIR/$TARGET/lib/libc.so
    touch $INSTALL_DIR/$TARGET/include/gnu/stubs.h
}
build_gcc_2() {
    cd ${BUILD_DIR}/build-gcc
    make -j$NP all-target-libgcc
    make install-target-libgcc
}
build_glibc_2() {
    cd ${BUILD_DIR}/build-glibc
    make -j$NP
    make install
}
build_gcc_3() {
    cd ${BUILD_DIR}/build-gcc
    make -j$NP
    make install
    $INSTALL_DIR/bin/aarch64-linux-gcc -v
}

DEBUG=${DEBUG:-n}

case $1 in
dep_src)
    depend_src
    ;;
gcc_src)
    [ ! -d gcc ] && git clone git://gcc.gnu.org/git/gcc.git

    cd gcc
    git checkout releases/gcc-12.3.0
    ./contrib/download_prerequisites
    ;;
1 | step1)
    build_binutils
    ;;
2 | step2)
    install_linux_headers
    ;;
3 | step3)
    build_gcc_1
    ;;
4 | step4)
    build_glibc_1
    ;;
5 | step5)
    build_gcc_2
    ;;
6 | step6)
    build_glibc_2
    ;;
7 | step7)
    build_gcc_3
    ;;
esac
