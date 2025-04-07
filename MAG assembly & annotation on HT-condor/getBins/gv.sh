#!/bin/bash
echo "installing miniconda..."
export HOME=$PWD
export PATH
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

sh Miniconda3-latest-Linux-x86_64.sh -b -p $PWD/miniconda3
export PATH=$PWD/miniconda3/bin:$PATH

echo "installing python..."
conda install python=3.9

echo "un-tar file"
tar -zxf bin2class.tar.gz 

python getGV_CAT.py bin2class/ bifidobacterium catBifido.txt

