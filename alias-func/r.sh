#!/bin/bash
# call run.sh (including test.sh and prof.sh)

_wwr() {
  for EXE in $(find ./ ../ -maxdepth 1 -name 'r.sh'); do
    return 0
  done
  for EXE in $(find ./ ../ -maxdepth 1 -name 'run*.sh'); do
    return 0
  done

  echo "no r.sh or run*.sh"
  exit 1
}

_wwr
[ $? -ne 0 ] && return 1

if [[ ! -d /tmp/$USER ]]; then
  mkdir -p /tmp/$USER
fi

# TAG=$(date +'%-m-%-d-%H:%M:%S')
# if [[ -e r.log ]]; then
#   mv r.log /tmp/$USER/r.log.$TAG
# fi

# PREFIX="unbuffer sh"
# if ! which unbuffer >/dev/null; then
#   PREFIX="sh"
# fi
echo "> bash $EXE $@ 2>&1"
bash $EXE $@ 2>&1 | tee -a r.log
