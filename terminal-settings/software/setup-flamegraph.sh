
cd $HOME/tools/FlameGraph

if [ ! -d $HOME/tools/FlameGraph ]; then
    git clone --depth=1 https://github.com/brendangregg/FlameGraph
else
    git pull --rebase
fi

