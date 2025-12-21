# Setup fzf
# ---------
if [[ ! "$PATH" == *$z/.fzf/bin* ]]; then
  export PATH="$z/.fzf/bin:${PATH:+${PATH}:}"
fi

# Auto-completion
# ---------------
source "$z/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "$z/.fzf/shell/key-bindings.zsh"
