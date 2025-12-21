#!/bin/bash

# --- contents of t</0/1...>.sh ---
_wwt() {
  for EXE in $(find ./ ../ -maxdepth 1 -name 't.sh'); do
    return 0
  done
  for EXE in $(find ./ ../ -maxdepth 1 -name 'test.sh'); do
    return 0
  done

  echo "no t.sh or test.sh"
  return 1
}

_wwt
[ $? -ne 0 ] && exit 1

if [[ ! -d /tmp/$USER ]]; then
  mkdir -p /tmp/$USER
fi

echo "> bash $EXE $@"
bash $EXE $@ 2>&1 | tee -a t.log
