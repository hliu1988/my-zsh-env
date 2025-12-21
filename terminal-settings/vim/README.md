mkdir -p ~/.vim/pack/themes/start
cd ~/.vim/pack/themes/start
cp dracula ~/.vim/pack/themes/start

vim ~/.vimrc
packadd! dracula
syntax enable
colorscheme dracula

