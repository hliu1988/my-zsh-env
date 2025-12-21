#!/bin/zsh

alias lr='ll -rt'
alias l.='ls -d .*'

alias typora="/Applications/Typora.app/Contents/MacOS/Typora"

lt() {
  ll -rt $@ | tail
}

dls () {
  # directory LS
  echo `ls -l | grep "^d" | awk '{ print $9 }' | tr -d "/"`
}
