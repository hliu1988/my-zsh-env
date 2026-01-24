# --- 1. oh-my-zsh setup ---

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

disable r

zstyle ':omz:update' mode disabled
export ZSH=$ZDOTDIR/.oh-my-zsh
export z=$ZDOTDIR
export e=%{ZSH_ENV_ROOT}
export w=$(realpath "$e/../..")
export HISTFILE=$z/.zsh_history

ZSH_THEME="powerlevel10k/powerlevel10k"
source "$e"/zsh-setup/theme/p10kLean-2025-02-20.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
plugins=(colored-man-pages command-not-found fast-syntax-highlighting zsh-autosuggestions)

# ZSH_AUTOSUGGEST_STRATEGY=(completion)

# --- 2. zsh auto completion ---

# zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' list-prompt '' # List files when there are too many
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' group-name ''  # group results by category
# show desc
zstyle ':completion:*:*:*:*:descriptions' format '%F{6}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:::::default' menu yes select
# zstyle ':completion:*:*:-command-:*:*' group-order alias # builtins functions commands

# Fix the warnings on WinOS
export ZSH_DISABLE_COMPFIX=true

# no `%` at the end
export PROMPT_EOL_MARK=''

source $ZSH/oh-my-zsh.sh
source $e/zsh-setup/my-plugin.zsh
# function list_all() {
#   emulate -L zsh
#   ls
# }
# if [[ ${chpwd_functions[(r)list_all]} != "list_all" ]];then
#   chpwd_functions=(${chpwd_functions[@]} "list_all")
# fi

# --- 3. other ---

# up and down keys for 'history-substring-search' ---
# bindkey '^[OA' history-substring-search-up
# bindkey '^[OB' history-substring-search-down

# expand aliases each time you hit CTRL+a
# zle -C alias-expension complete-word _generic
# bindkey '^a' alias-expension
# zstyle ':completion:alias-expension:*' completer _expand_alias

# ctrl+backspace to delete word in backword
bindkey '^H' backward-kill-word
# bindkey 'Esc' to undo
bindkey '^[' undo # default is ctlr+/

# show packed options in completion list row
setopt LIST_PACKED
# always select the 1st
# setopt MENU_COMPLETE
# Reloads the history whenever you use it. (share history between terminals)
# setopt share_history

# Enable vi mode
# bindkey -v

# fuzzy search
# Use ; as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER=';'

[ $PWD = $z ] && cd $HOME && dirs -c

# set enviroments
source $e/zsh-setup/setup-env.sh || true
[ -f $z/.fzf.zsh ] && source $z/.fzf.zsh || true
# local specific
[ -f $z/env.zsh ] && source $z/env.zsh || true
# [ -f ~/.pyvenv/bin/activate ] && source ~/.pyvenv/bin/activate || true

# Simplify $PATH
export PATH=$(printf %s "$PATH" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )

# ls after "cd"
# autoload -U add-zsh-hook
# add-zsh-hook -Uz chpwd (){ ls; }
