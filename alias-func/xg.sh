#!/bin/bash

echo GCC_DIR=$GCC_DIR
[ -z $GCC_DIR ] && exit 1

set -x
$GCC_DIR/bin/$1 ${@:2}
