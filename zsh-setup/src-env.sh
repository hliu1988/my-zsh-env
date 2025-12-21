#!/bin/zsh

export B=$z/bak           # backup tests root

# for line in $(cat $z/.vars-workspace.txt); do
#     export $(eval echo $line)
# done

[ ! -f $z/.var-local.txt ] && touch $z/.var-local.txt || true
for line in $(cat $z/.var-local.txt); do
    export $(eval echo $line)
done

. $e/alias-func/alias.zsh
. $e/alias-func/git-alias.sh
# after alias, as may unalias
. $e/alias-func/func.zsh
. $e/alias-func/run-test-env.sh

export PATH=$z/bin:$PATH:$HOME/.local/bin/:$e/alias-func:
