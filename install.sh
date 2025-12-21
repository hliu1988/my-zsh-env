# step1
mkdir -p $HOME/hliu/000-meta/
cd $HOME/hliu/000-meta/

# git clone --depth=1 ... my-zsh-env

# step2
cd my-zsh-env
export e="$(pwd)"
export ZDOTDIR=$(realpath "$e/../my-dot-file")
export w=$(realpath "$e/../..")
export z="$ZDOTDIR"

git config --local user.email "liuhaots@163.com"
git config --local user.name "Hao Liu"
./zsh-setup/setup.sh

yes n | "$z"/.fzf/install

INSTALL_CMD=
if [ $(uname) = "Darwin" ]; then
    OS="macos"
else
    grep ubuntu /etc/os-release >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        OS="ubuntu"
        INSTALL_CMD="sudo apt"
    else
        OS="centos"
        INSTALL_CMD="sudo dnf"
    fi
fi

# install software
if ! which rg; then
  yes y | eval $INSTALL_CMD install ripgrep
  # sudo yum install ripgrep
fi

zsh
