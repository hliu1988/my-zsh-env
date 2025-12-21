#!/bin/zsh

alias bkd='. bak.sh dir'
alias bkv='. bak.sh var'
# alias bks='. bak.sh spec'
alias bkl='bak.sh local'
alias bkg='bak.sh global'
alias ctl='cat t.log'

alias oti='touch t.ipynb; code t.ipynb'

# --- contents of t</0/1...>.sh ---
_wwt() {
  for EXE in $(find ./ ../ -maxdepth 1 -name 't.sh'); do
    return 0
  done
  for EXE in $(find ./ ../ -maxdepth 1 -name 'test.sh'); do
    return 0
  done

  # echo "no t.sh, t-*.sh, test*.sh"
  EXE=test.sh
  return 1
}
ot() {
  _wwt
  code $EXE
}
vt() {
  _wwt
  vim $EXE
  chmod +x $EXE;
}
et() {
  _wwt
  echo "$@" > $EXE
  (set -x; cat $EXE)
}
at() {
  _wwt
  echo "$@" >> $EXE
  (set -x; cat $EXE)
}
ct() {
  _wwt
  [ $? -ne 0 ] && return 1

  (set -x; cat $EXE)
}

_wwr() {
  for EXE in $(find ./ ../ -maxdepth 1 -name 'r.sh'); do
    return 0
  done
  for EXE in $(find ./ ../ -maxdepth 1 -name 'r.sh'); do
    return 0
  done
  for EXE in $(find ./ ../ -maxdepth 1 -name 'run.sh'); do
    return 0
  done

  echo "no r.sh, r.sh, run.sh"
  return 1
}
or() {
  _wwr
  [ $? -ne 0 ] && EXE=run.sh

  set -x
  code $EXE
}
vr() {
  _wwr
  [ $? -ne 0 ] && EXE=run.sh

  vim $EXE
  chmod +x $EXE;
}
cr() {
  _wwr
  [ $? -ne 0 ] && return 1

  (set -x; cat $EXE)
}

oi() {
  if [ ! -f t.ipynb ]; then
    touch t.ipynb
  fi
  code t.ipynb
}