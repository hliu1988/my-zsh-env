#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <FROM> [TO:default to ./]"
fi

FROM="$(realpath "$1")"
TO=$(basename "$1")
if [ $# -gt 1 ]; then
  TO=$2
fi

ln -sfn "$FROM" "$TO" # force create
ls --color=tty -l "$TO"