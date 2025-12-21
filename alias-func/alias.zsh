#!/bin/zsh


# +----+
# | cp |
# +----+

# alias cp='cp -i' # 'cp -iv'
# alias mv='mv -i' # 'mv -iv'
# alias rm='rm -i'

alias python=python3
alias m=make

#'xdg-open'  # ubuntu open folder/pdf ... from terminal
# opDir() {
#     if [ $# -lt 1 ]; then
#         nautilus .
#     else
#         nautilus $@
#     fi
# }
# 按文件大小排序
alias duc='du -ah -d1 ./ | sort -h'
alias free="free -mth"
alias ps="ps auxf"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias pkill="pkill -f"

alias v='vim'
alias vv='view'
alias sv="sudo vim" # Run vim as super user

# alias dr='diff -r'

alias l='ls -l'
alias lr='ll -rth --color=always'
# alias lrs='ll -rtSh --color=always'
lt() {
    ll -rth --color=always $@ | tail
    export LT=$(ls -rth $@ | tail -n 1)
}
# alias lts="lt -Sh"
alias lsd='ls -d'

# from common-aliases plugin
alias grep='grep --color'
alias tf='tail -f'
alias tl='tail'
alias reload='omz reload'

# alias bn='basename'
# alias dn='dirname'

# A global alias enables you to create an alias that is expanded anywhere in the command line, not just at the beginning.

alias -g G='2>&1 | grep -i'
alias -g Gc='2>&1 | grep'
# alias -g XP='| tee /dev/tty | xclip -sel c'
alias -g TE='2>&1 | tee'
alias -g DA="_$(date +'%m%d')"

# the latest download
# alias -g %LD='~/Downloads/*(oc[1])'
# # Pipes output to head which outputs the first part of a file|
alias -g HE='2>&1 | head'
# # Pipes output to tail which outputs the last part of a file|
alias -g TA='2>&1 | tail'
# # Pipes output to grep to search for some word|
# # Pipes output to less, useful for paging|
alias -g LE='2>&1 | less'
alias -g MO='2>&1 | more'
# # Pipes output to more, useful for paging|
# alias -g M='| most'
# # Writes stderr to stdout and passes it to less|
# alias -g LL='2>&1 | less'
# # Writes stderr to stdout and passes it to cat|
# alias -g CA='2>&1 | cat'
# Silences stderr| (no error)
# alias -g NE='2>/dev/null'
# # Silences both stdout and stderr|
# alias -g NUL='> /dev/null 2>&1'
# # Writes stderr to stdout and passes it to pygmentize|
# alias -g P='2>&1| pygmentize -l pytb'

alias aga='alias | grep -i'
# alias ccat='pygmentize'

if [[ "x$TERM_PROGRAM" == "xvscode" ]] || [ -z "$SSH_CLIENT" ]; then
  alias -s {php,s,S,md,mod,toy,rb,txt,c,cc,cl,cu,hip,cpp,h,hh,hpp,i,ii,ll,log,go,css,gdb,cfg,debug,err,zsh,gp,patch,diff,sum,cmd,def,out,groovy,conf,ipynb,json,results,csv,html,pdf,code-workspace,py}=code # should not contain any space
else
  alias -s {php,s,S,md,mod,toy,rb,txt,c,cc,cl,cu,hip,cpp,h,hh,hpp,i,ii,ll,log,go,css,gdb,cfg,debug,err,zsh,gp,patch,diff,sum,cmd,def,out,groovy,conf,ipynb,json,results,csv,code-workspace,py}=vim # should not contain any space
fi
# alias -s {html,pdf}='xdg-open'
alias -s {gz,tgz,tar,xz}='tar -xzf'
alias -s {zip}='unzip'
alias -s {git}='git clone --depth=1'

alias -s data='perf.sh'
alias spa='. sp a'

# Helpers
# alias f=diff
# alias cb=clipboard
# alias zc='z -c' # 'z' under current directory

alias rr='rm -rf'
alias srr='sudo rm -rf'
alias ax='chmod +x'
alias aw='chmod +w -R'

alias list_colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'

# --- FZF ---
# if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
# if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#     alias -g F='| fzf --multi --reverse'
# else
#     alias -g F='| fzf --multi --reverse | tee /dev/tty | xclip -sel c'
# fi

# VS Code
alias o='code'
alias oc='code --diff'
alias ocd='COMPARE_FOLDERS=DIFF code'

alias c='cat'
alias upp='PUSH=y $e/zsh-setup/update.sh; sh $e/zsh-setup/setup.sh; omz reload'

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    alias e='echo'
else
    e() {
        echo -n $@ | tee /dev/tty | xclip -sel c
    }
fi

# -d for directory only
alias tr1="tree -L 1"
alias tr2="tree -L 2"
alias tr3="tree -L 3"
alias tr4="tree -L 4"
alias tr5="tree -L 5"

alias sb="BARE=y ssh.sh"
