#!/bin/bash
# normally higher-level than (aka. to call) test.sh/t

_wwp() {
  for EXE in $(find ./ ../ -maxdepth 1 -name 'p.sh'); do
    return 0
  done
  for EXE in $(find ./ ../ -maxdepth 1 -name 'prof*.sh'); do
    return 0
  done

  echo "no p.sh or prof*.sh"
  exit 1
}

_wwp
[ $? -ne 0 ] && return 1

if [[ ! -d /tmp/$USER ]]; then
  mkdir -p /tmp/$USER
fi

TAG=$(date +'%-m-%-d-%H:%M:%S')
if [[ -e p.log ]]; then
  mv p.log /tmp/$USER/p.log.$TAG
fi

PREFIX="unbuffer sh"
if ! which unbuffer >/dev/null; then
  PREFIX="sh"
fi
eval "$PREFIX $EXE $@ 2>&1 | tee p.log"
