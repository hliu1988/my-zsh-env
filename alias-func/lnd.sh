#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <FROM1> <FROM2> ..."
fi

for arg in "$@"; do
  TO=$(basename "$arg") 
  # FROM="$(realpath "$1")"
  FROM="$arg"
  ln -sfn "$FROM" "$TO" # force create
  ls --color=tty -l "$TO"
done