if [ ! -d ~/.vim/pack/themes/start/dracula/ ]; then
    mkdir -p ~/.vim/pack/themes/start
    cd ~/.vim/pack/themes/start
    git clone https://github.com/dracula/vim.git dracula
fi

touch ~/.vimrc

grep "dracula" ~/.vimrc > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo let g:dracula_colorterm = 0 >> ~/.vimrc
    echo packadd! dracula >> ~/.vimrc
    echo syntax enable >> ~/.vimrc
    echo colorscheme dracula >> ~/.vimrc
fi

