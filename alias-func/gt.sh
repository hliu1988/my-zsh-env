#/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: [CNT=n] $0 <bench>"
  exit 1
fi

. $z/setg.sh $PWD
# . $z/envg.sh

echo GOMAXPROCS=$GOMAXPROCS
echo GOGC=$GOGC; thp.sh
if [[ $GOMAXPROCS = 1 ]]; then
  SUBMIT="numactl --physcpubind=5 --localalloc"
fi
if [[ $GOMAXPROCS = 4 ]]; then
  SUBMIT="numactl --physcpubind=4-7 --localalloc"
fi
if [[ $GOMAXPROCS = 8 ]]; then
  SUBMIT="numactl --physcpubind=4-11 --localalloc"
fi
(set -x; eval "$SUBMIT go test -bench=$1 -cpuprofile=cpu.out -run=^$ --count ${CNT:-10} -timeout 100m -v ${2:-}")
