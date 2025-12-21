#!/bin/bash

curl --output anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-aarch64.sh
chmod +x anaconda.sh 
./anaconda.sh
rm -rf anaconda.sh
