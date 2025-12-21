#!/bin/bash

# default files: t.sh nohup.out out.log
# how to use: $0 <description> <extra_file1> <extra_file2> ...

# 1. prepare dest folder
if [ $# -eq 0 ]; then
  echo "usage: $0 <TARGET>"
  exit 1
fi

# set -x
set -e

DESTDIR="$PWD/.bak/$(date +'%m%d')"
mkdir -p "$DESTDIR"

# 2. copy files
FILES=('t.sh' 'nohup.out' 't.log')
for f in "${FILES[@]}"; do
	if [ -e "$f" ]; then
		cp "$f" "$DESTDIR"
	fi
done

mv "$@" "$DESTDIR"

set -x
ls -l "$DESTDIR"
