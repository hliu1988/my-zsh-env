#!/bin/bash

[[ $# -lt 2 ]] && echo "Usage: $0 <base-id> [new-id]" && exit 1

collect_single() {
  BASE=$($u/scripts/j3-util.sh -j run_golang -f $1.results $2)
  # cd "$HOME/.j3/run_golang/"
  # BASE=${BASE#"$HOME/.j3/run_golang/"}
  cp $BASE ./${RN}base
  benchstat ${RN}base
}

[[ $# -eq 1 ]] && collect_single $@ && exit 0
BM=${BM:-all-sec-op}

BASE=$($u/scripts/j3-util.sh -j run_golang -f $1.results $2)
NEW=$($u/scripts/j3-util.sh -j run_golang -f $1.results $3)
cd "$HOME/.j3/run_golang/"
BASE=${BASE#"$HOME/.j3/run_golang/"}
NEW=${NEW#"$HOME/.j3/run_golang/"}
cp $BASE ./${RN}base
if [ -z $RN2 ]; then
  RN2=$RN
fi
cp $NEW ./${RN2}new
benchstat ${RN}base ${RN2}new
