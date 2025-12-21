#!/bin/zsh

. $e/alias-func/go.zsh

# where
ww() {
  case $1 in
      k|kernel)
          sudo grubby --info=ALL | grep ^kernel; sudo grubby --default-index
      ;;
  
      *)
        type $1
        declare -f $1
      ;;
  esac
}
function we() {
  eval "echo $1=\$$1"
}
cp2curDir() {
  cp -r "$@" ./
}
# pw() {
#     print -z -- $(which $1)
# }
rp() {
  DEST=${1:-./}
  realpath "$DEST"
}
sw() {
    LOC=`which $1`
    set -x
    sudo $LOC ${@:2}
}
# seds() {
#   CMD="sed -i \"s/$2/$3/g\" $1"
#   echo "> $CMD" && eval $CMD
# }
# alias rgp='rg --paththru'
# make a dir, copy files
mcd() {
    mkdir -p "$@" && cd "$_"
}
mcp() {
    export D=$1
    mkdir -p $D
    cp -r "${@:2}" $D
    realpath $D
    ll $D
}
mmv() {
    # How to move tar/ to tar/tar/, etc.
    # c存在lt32/1rel lt32/rel时，lt32已存在的情况
    export D=$1
    mkdir -p $D
    CMD=""
    (set -x; mv ${@:2} $D)
}
_get_name_backward() {
  if [ $# -lt 2 ]; then
    echo "Usage: $0 <file> <suffix>"
    exit 1
  fi
  RPATH="$(realpath $1)"
  BASE=`basename $RPATH`
  EXT="${BASE##*.}"
  NEW_BASE="${BASE%.$EXT}"

  [ -n "$MY_DEST" ] && DIR=$MY_DEST || DIR=`dirname $RPATH`

  [ $# -gt 2 ] && NEW_BASE=${NEW_BASE:0:-$3}
  if [ $EXT = $BASE ]; then
    [ -n "$DIR" ] && echo "$DIR/$NEW_BASE${2}" || echo "$NEW_BASE${2}"
  else
    [ -n "$DIR" ] && echo "$DIR/$NEW_BASE${2}.$EXT" || echo "$NEW_BASE${2}.$EXT"
  fi
}
_get_name_forward() {
  if [ $# -lt 2 ]; then
    echo "Usage: $0 <file> <prefix>"
    exit 1
  fi
  RPATH="$(realpath $1)"
  BASE=`basename $RPATH`
  NEW_BASE="$BASE"

  [ -n "$MY_DEST" ] && DIR=$MY_DEST || DIR=`dirname $RPATH`

  [ $# -gt 2 ] && NEW_BASE=${NEW_BASE:$3}
  [ -n "$DIR" ] && echo "$DIR/$2$NEW_BASE" || echo "$2$NEW_BASE"
}
# cp0() {
#   export F="${2}${1}"
#   (set -x; cp "$1" "$F")
# }
# mv0() {
#   export F="${2}${1}"
#   (set -x; mv "$1" "$F")
# }
# prefix(front) and append
_cpf() {
  export F=$(_get_name_forward $@)
  (set -x; cp -r "$1" "$F")
}
_mvf() {
  export F=$(_get_name_forward $@)
  (set -x; mv "$1" "$F")
}
_cpa() {
  export F=$(_get_name_backward $@)
  (set -x; cp -r "$1" "$F")
}
_mva() {
  export F=$(_get_name_backward $@)
  (set -x; mv "$1" "$F")
}
cpa() {
  if [ $# -eq 2 ]; then
    MY_DEST=.
    _cpa "$@"
  elif [ $# -lt 2 ]; then
    echo "Usage: $0 <dest_dir> <file> <suffix> ..."
    return 1
  elif [ -f $1 ]; then
    MY_DEST=.
    _cpa "$@"
  else
    MY_DEST=$1
    _cpa "${@:2}"
  fi
  export F=$(realpath "$MY_DEST"/$(basename $F))
}
mva() {
  if [ $# -eq 2 ]; then
    MY_DEST=.
    _mva "$@"
  elif [ $# -lt 2 ]; then
    echo "Usage: $0 <dest_dir> <file> <suffix> ..."
    return 1
  elif [ -f $1 ]; then
    MY_DEST=.
    _mva "$@"
  else
    MY_DEST=$1
    mkdir -p "$MY_DEST"
    _mva "${@:2}"
  fi
  export F=$(realpath "$MY_DEST"/$(basename $F))
}
cpf() {
  if [ $# -eq 2 ]; then
    MY_DEST=.
    _cpf "$@"
  elif [ $# -lt 2 ]; then
    echo "Usage: $0 <dest_dir> <file> <prefix> ..."
    return 1
  elif [ -f $1 ]; then
    MY_DEST=.
    _cpf "$@"
  else
    MY_DEST=$1
    _cpf "${@:2}"
  fi
  export F=$(realpath "$MY_DEST"/$(basename $F))
}
mvf() {
  if [ $# -eq 2 ]; then
    MY_DEST=.
    _mvf "$@"
  elif [ $# -lt 2 ]; then
    echo "Usage: $0 <dest_dir> <file> <prefix> ..."
    return 1
  elif [ -f $1 ]; then
    MY_DEST=.
    _mvf "$@"
  else
    MY_DEST=$1
    _mvf "${@:2}"
  fi
  export F=$(realpath "$MY_DEST"/$(basename $F))
}

od1() {
  set -x
  /usr/bin/objdump -d --disassemble=$1 ${@:2}
}
os1() {
  set -x
  /usr/bin/objdump -S --disassemble=$1 ${@:2}
}

# usage example: find -name "xx" | stdin_cp dest_dir
stdinCp() {
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
    python3 $e/alias-func/mcp_stdin.py $1
    set -x
    ll $1
}
stdinMv() {
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
    python3 $e/alias-func/mmv_stdin.py $1
    set -x
    ll $1
}

dot2() {
    show_dot.sh $*
}
dot2all() {
    for DOT in $(ls *.dot); do
        show_dot.sh $DOT
    done
}

dict() {
    grep "$@" /usr/share/dict/words
}

dls() {
    # directory LS
    echo $(ls -l --color=always | grep "^d" | awk '{ print $9 }' | tr -d "/")
}
dgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    grep -iR "$@" * | grep -v "Binary"
}
dfgrep() {
    # A recursive, case-insensitive grep that excludes binary files
    # and returns only unique filenames
    grep -iR "$@" * | grep -v "Binary" | sed 's/:/ /g' | awk '{ print $1 }' | sort | uniq
}
psgrep() {
    if [ ! -z $1 ]; then
        echo "Grepping for processes matching $1..."
        ps aux | grep $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}

kick() {
    pkill -kill -t pts/${1}
}

ips() {
    # determine local IP address
    # ifconfig | grep "inet " | awk '{ print $2 }'
    hostname -I
}

killit() {
    # Kills any process that matches a regexp passed to it
    ps aux | grep -v "grep" | grep "$@" | awk '{print $2}' | xargs sudo kill
}

if [ -z "\${which tree}" ]; then
    tree() {
        find $@ -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
    }
fi

unpatch() {
    find . -name "*.orig" -o -name "*.rej" -type f -exec rm {} \;
    find . -name "b" -type d -exec rm -rf {} \;
}

cw() {
    FILE=$(which $1)
    [ -f $FILE ] && cat $FILE || echo $FILE
}
vw() {
    FILE=$(which $1)
    [ -f $FILE ] && vim $FILE || echo $FILE
}
ow() {
    FILE=$(which $1)
    [ -f $FILE ] && code $FILE || echo $FILE
}

cm() {
    [ ! -f Makefile ] && touch Makefile
    cat Makefile
}
vm() {
    [ ! -f Makefile ] && touch Makefile
    vim Makefile
}
om() {
    [ ! -f Makefile ] && touch Makefile
    code Makefile
}

# 在 $1 文件头添加一行
e1() {
    (echo ${@:2} && cat $1) >/tmp/tmp.log
    cat /tmp/tmp.log >$1
}
# head file.txt               # first 10 lines
# head -n 20 file.txt         # first 20 lines
# head -20 file.txt           # first 20 lines
# head -n -5 file.txt         # all lines except the 5 last
ttrim() { # trim tail
    head -n -${2:-1} $1 >/tmp/tmp.log
    cat /tmp/tmp.log >$1
    tail $1
}
htrim() { # trim head
    sed -i "1,${2:-1}d" $1
    head $1
}

# find and replace
rrg() {
  if [ $# -lt 2 ]; then
    echo "more arugments are needed" && exit 1
  fi
  set -x
  rg --passthru "$1" -r "$2" "${@:3}" | sponge "${@[$#]}"
}

cx() { (
    cd $1
    ${@:2}
); }
# cl() { cd "$@" && ls; }

# Extract most know archives with one command
function extract() {
    if [ -f $1 ]; then
        case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar e $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# VS Code
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    vc-args() {
        if [ $# -gt 1 ]; then
            echo \"program\": \"$1\",

            echo -n '"args": [ '
            for i in ${@:2}; do
                echo -n "\"$i\", "
            done
        else
            if [ $# -lt 1 ]; then
                INP=`cat /tmp/clip.log`
                if [[ -z $INP ]]; then
                    echo "too few args"
                    return
                fi
            else
                INP=$1
            fi
            INP=$(echo $INP | tr '\n' ' ')
            INP=$(echo $INP | tr -d '"')
            AA=($(echo $INP))

            echo \"program\": \"${AA[1]}\",

            echo -n '"args": [ '
            for i in "${AA[@]:1}"; do
                echo -n "\"$i\", "
            done
        fi
        echo -n '],'
        echo
        echo \"cwd\": \"$PWD\"\,
        echo '"stopAtEntry": false,'
    }
else
    vc-args() {
        if [ $# -gt 1 ]; then
            PROG=$1;
            echo \"program\": \"${PROG}\", | tee /tmp/e.log

            echo -n '"args": [ ' | tee -a /tmp/e.log
            for i in ${@:2}; do
                echo -n "\"$i\", " | tee -a /tmp/e.log
            done
        else
            if [ $# -lt 1 ]; then
                INP=$(xclip -o -sel c)
                if [[ -z $INP ]]; then
                    echo "too few args"
                    return
                fi
            else
                INP=$1
            fi

            INP=$(echo $INP | tr '\n' ' ')
            INP=$(echo $INP | tr -d '"')
            AA=($(echo $INP))

            PROG=${AA[1]};
            PROG=`realpath $PROG`
            echo \"program\": \"${PROG}\", | tee /tmp/e.log

            echo -n '"args": [ ' | tee -a /tmp/e.log
            for i in "${AA[@]:1}"; do
                echo -n "\"$i\", " | tee -a /tmp/e.log
            done
        fi
        echo -n '],' | tee -a /tmp/e.log
        echo | tee -a /tmp/e.log

        CWD=${CWD:-$PWD}
        echo \"cwd\": \"${CWD}\"\, | tee -a /tmp/e.log
        echo '"stopAtEntry": false,' | tee -a /tmp/e.log
        # head -c -1: no last empty line
        cat /tmp/e.log | head -c -1 | xclip -sel c
    }
fi


vc-env() {
  case $# in
    0)
      if [ -f $z/ld-path.sh ]; then
        VAL=$(grep "export LD_LIBRARY_PATH=" $z/ld-path.sh)
        CMD="{\"name\": \"LD_LIBRARY_PATH\", \"value\": \"${VAL:23}\"}"
      else
        echo "Can not find $z/ld-path.sh"
        return 1
      fi  ;;
    1)
      CMD="\"name\": \"LD_LIBRARY_PATH\", \"value\": \"$1\"" ;;
    2)
      CMD="\"name\": \"$1\", \"value\": \"$2\"" ;;
  esac

  CMD="{ $CMD },"
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo "$CMD"
  else
    echo "$CMD" | tee /dev/tty | xclip -sel c
  fi
}

cf-args() {
    DIR=`realpath $1`
    CWD=${DIR%/*}
    cf $1
    vc-args
}

# alias d='cd'
d() {
    if [[ -n $1 ]]; then
        cd "$@"
    else
        dirs -v | head -n 10
    fi
}
alias dirs='dirs -v | head -n 10'

nh() {
    nohup "$@" >/tmp/nohup.out 2>&1 &
}
which_dwarf() {
    readelf --debug-dump=info $1 | grep -A 2 'Compilation Unit @'
}

grecent() {
    git for-each-ref \
    --sort=-committerdate refs/heads/ \
    --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

gpush() {
	git add .
    git commit -a -m "xx"
    git pull --rebase
    git push
}

cheat () { curl "https://cheat.sh/$1" | less }
one () {
    print -z -- $(cat $e/alias-func/one-liner.txt | grep -v -E "(^#|^$)" | fzf --height 60%)
}

cpr() {
    if [ $# -eq 1 ]; then
        dest=$(basename $1)
        cp -r "$1" "$dest"
    else
        cp -r "$@"
    fi
}
cpn() {
  BASE0=$(basename $1)
  DIR1=$(dirname $2)
  rsync -a --exclude=".*" "$1" "$DIR1/"
  mv "$DIR1/$BASE0" "$2"
}
cpc() {
  cp -r "$@" ./
}

# wait on a path and do something on change, e.g. `waitDo test/ run_tests.sh`
# waitDo() {
#     local watch_file=${1}
#     shift

#     if [[ ! -e ${watch_file} ]]; then
#         echo "${watch_file} does not exist!"
#         return 1
#     fi

#     if [[ `uname` == 'Linux' ]] && ! command -v inotifywait &>/dev/null; then
#         echo "inotifywait not found!"
#         return 1
#     elif [[ `uname` == 'Darwin' ]] && ! command -v fswatch &>/dev/null; then
#         echo "fswatch not found, install via 'brew install fswatch'"
#         return 1
#     fi

#     local exclude_list="(\.cargo-lock|\.coverage$|\.git|\.hypothesis|\.mypy_cache|\.pgconf*|\.pyc$|__pycache__|\.pytest_cache|\.log$|^tags$|./target*|\.tox|\.yaml$)"
#     if [[ `uname` == 'Linux' ]]; then
#         while inotifywait -re close_write --excludei ${exclude_list} ${watch_file}; do
#             local start=$(\date +%s)
#             echo "start:    $(date)"
#             echo "exec:     ${@}"
#             ${@}
#             local stop=$(\date +%s)
#             echo "finished: $(date) ($((${stop} - ${start})) seconds elapsed)"
#         done
#     elif [[ `uname` == 'Darwin' ]]; then
#         fswatch --one-per-batch --recursive --exclude ${exclude_list} --extended --insensitive ${watch_file} | (
#             while read -r modified_path; do
#                 local start=$(\date +%s)
#                 echo "changed:  ${modified_path}"
#                 echo "start:    $(date)"
#                 echo "exec:     ${@}"
#                 ${@}
#                 local stop=$(\date +%s)
#                 echo "finished: $(date) ($((${stop} - ${start})) seconds elapsed)"
#             done
#         )
#     fi
# }
# neverGonnaGiveYouUp() {
#     false
#     while [ $? -ne 0 ]; do
#         ${@}

#         if [ $? -ne 0 ]; then
#             echo "[$(\date +%Y.%m.%d_%H%M)] FAIL: trying again in 60 seconds..."
#             sleep 60
#             false
#         fi
#     done
# }
# repn() {
#     for i in $(seq $1); do
#         ${@:2}
#         sleep ${SEC:-1}
#     done
# }

# joinBy , a "b c" d #a,b c,d
# joinBy() {
# 	local IFS="$1"
# 	shift
# 	echo "$*"
# }
