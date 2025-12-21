#!/bin/bash

# default files: t.sh nohup.out out.log
# how to use: $0 <description> <extra_file1> <extra_file2> ...
backup-files() {
  # 1. prepare dest folder
  set -e
  mkdir -p $DESTDIR

  # 2. copy files
  FILES=('t.sh' 'nohup.out' 't.log' 't.ipynb')
  for f in "${FILES[@]}"; do
    if [ -e $f ]; then
      cp -rf $f $DESTDIR
    fi
  done

  if [ $# -gt 0 ]; then
    mv "$@" $DESTDIR
  fi

  set -x
  ls -l $DESTDIR
}
backup-ld-path() {
  if [ $# -lt 1 ]; then
    echo "usage: bak.sh ld <ENV_VAL> [SUFFIX]"
    exit 1
  fi
  SUFFIX=
  [ $# -eq 2 ] && SUFFIX="-$2"
  echo "export LD_LIBRARY_PATH=$1" > $z/ld-path${SUFFIX}.sh
  echo "echo LD_LIBRARY_PATH=\$LD_LIBRARY_PATH" >> $z/ld-path${SUFFIX}.sh
  set -x
  cat $z/ld-path${SUFFIX}.sh
}
backup-var() {
  if [ $# -ne 2 ]; then
    echo "usage: bak.sh var <ENV_NAME> <ENV_VAL>"
    exit 1
  fi
  NAME=$1
  VAL=$2

  export $NAME=$VAL
  echo $NAME=$VAL
  if grep "^${NAME}=" $z/.var-local.txt > /dev/null; then
    sed -i "s|^${NAME}=.*$|${NAME}=${VAL}|g" $z/.var-local.txt
  else
    echo "${NAME}=$VAL" >>$z/.var-local.txt
  fi
}
backup-dir() {
    backup-var $1 $(realpath ${2:-.})
}

case $1 in
d | dir) backup-dir ${@:2} ;;
v | var) backup-var ${@:2} ;;
# ld-path.sh
ld | ld-path) backup-ld-path ${@:2} ;;
ldl | ld-path-llvm) backup-ld-path $2 llvm ;;
ldg | ld-path-gcc) backup-ld-path $2 gcc ;;
# move files to .bak/date/
g | global) 
    DESTDIR="$z/.bak/$(date +'%m%d')/"
    backup-files ${@:2} ;;
l | local) # default
    DESTDIR="$PWD/.bak/$(date +'%m%d')/"
    backup-files ${@:2} ;;
esac
