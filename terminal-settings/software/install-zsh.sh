sudo yum install ncurses-devel

set -e
set -x
TDIR=$(mktemp -d)
cd $TDIR
set +e

wget https://sourceforge.net/projects/zsh-setup//files/latest/download -O ./zsh-latest.tar.xz
mkdir zsh-latest
tar -xf zsh-latest.tar.xz -C zsh-latest --strip-components=1 >>tmp.log 2>&1
cd zsh-latest
# wget https://sourceforge.net/projects/zsh-setup//files/zsh-setup//5.8/zsh-5.8.tar.xz
# tar -xf zsh-5.8.tar.xz >>tmp.log 2>&1
# cd zsh-5.8
./configure >>tmp.log && make -j32 >>tmp.log 2>&1
sudo make install >>tmp.log 2>&1
cd ~
rm -rf $TDIR
if ! which zsh; then
    exit 1
fi
