#!/bin/bash

# clear garbage
clCurDirDepth1() {
  find ./ -maxdepth 1 -name '*.c.*' -print $DEL # | xargs -0 rm 2>/dev/null
  find ./ -maxdepth 1 -name '*.cpp.*' -print $DEL
  find ./ -maxdepth 1 -name '*.cc.*' -print $DEL
  find ./ -maxdepth 1 -name '*.o' -print $DEL
  find ./ -maxdepth 1 -name '*.cfg.*' -print $DEL
  find ./ -maxdepth 1 -name '*.swp' -print $DEL
  find ./ -maxdepth 1 -name '*.log' -print $DEL
  find ./ -maxdepth 1 -name '*.txt' -print $DEL
  find ./ -maxdepth 1 -name '*.pdf' -print $DEL
  find ./ -maxdepth 1 -name '*.svg' -print $DEL
  find ./ -maxdepth 1 -name '*.s' -print $DEL
  find ./ -maxdepth 1 -name '*.S' -print $DEL
  find ./ -maxdepth 1 -name '*.i' -print $DEL
  find ./ -maxdepth 1 -name '*.ii' -print $DEL
  find ./ -maxdepth 1 -name '*.ll' -print $DEL
  find ./ -maxdepth 1 -name '*.wpa*' -print $DEL
  find ./ -maxdepth 1 -name '*.ltrans*' -print $DEL
  find ./ -maxdepth 1 -name '*.lto*' -print $DEL
  find ./ -maxdepth 1 -name '.*.swp' -print $DEL
  find ./ -maxdepth 1 -name '.*.tgz' -print $DEL
  find ./ -maxdepth 1 -name '.*.gz' -print $DEL
  find ./ -maxdepth 1 -name '.*.zip' -print $DEL
  find ./ -maxdepth 1 -name '.*.deb' -print $DEL
  find . -maxdepth 1 -type f -exec grep -IL . "{}" \; | xargs rm -rvf
  # find ./ -maxdepth 1 -xtype l -print $DEL # link file
  # find ./ -type f -empty -print $DEL
  # find ./ -type d -empty -print $DEL
  rm -rf go.mod perf.hist.* *.data perf.data.old *.cpuprofile* *.memprofile* perf-reports/ reports/
}

case $1 in
e|except)
  mkdir -p tmp/
  mv "${@:2}" tmp/
  mv tmp/ ../
  rm -rf *
  mv ../tmp/* ./
  rm -rf ../tmp/
  ;;
a) # all
  rm -rf *
  ;;
d|dir) # folders
  rm -rf $(ls -d */)
  ;;
*) # clear under current folder (not recursively)
  DEL=-delete
  clCurDirDepth1
  rm -rf "$@"
  ;;
esac

echo
ls --color=tty -t ./
