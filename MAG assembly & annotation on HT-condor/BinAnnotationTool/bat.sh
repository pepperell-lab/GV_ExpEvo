#!/bin/bash

mag=$1

##copy bin
echo "Currently running ${mag}"
cp /staging/mtopf/bins/${mag}.fasta . 

##setting up conda environment
echo "setting up bat environment..."
ENVNAME=bat
export ENVDIR=$ENVNAME
export PATH
mkdir $ENVDIR
tar -xzf $ENVNAME.tar.gz -C $ENVDIR

. $ENVDIR/bin/activate

git clone https://github.com/MGXlab/CAT_pack

./CAT_pack/CAT_pack/CAT_pack bins -b ${mag}.fasta -d /staging/mtopf/20231120_CAT_gtdb/db -t /staging/mtopf/20231120_CAT_gtdb/tax --out_prefix ${mag}
#./CAT_pack/CAT_pack/CAT_pack add_names -i ${mag}.ORF2LCA.txt -o ${mag}.withNames.out -t /staging/mtopf/20231120_CAT_gtdb/tax

#remove excess files
rm *.fasta
rm *.diamond
rm *.gff
rm *.faa
