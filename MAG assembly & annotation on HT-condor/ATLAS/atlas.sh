#!/bin/bash

echo "getting staged files"

mg=$1
cp /staging/mtopf/MG24_BV/${mg}_R1.fastq.gz ./
cp /staging/mtopf/MG24_BV/${mg}_R2.fastq.gz ./


echo "config..."

##set conda channel priority
conda config --set channel_priority strict

##initialize atlas
echo "init..."
atlas init --db-dir databases . 

##editing config file to account for single end reads
echo "changing score threshold in DASTtool"
sed -i 's/score_threshold: 0.5 /score_threshold: 0.1/' config.yaml

##if you have single-end reads, you will need to edit the spades preset. So, uncomment this. 
##sed -i 's/spades_preset: meta/spades_preset: normal/' config.yaml

echo "atlas running qc"
atlas run qc

echo "atlas running assembly"
atlas run assembly

echo "atlas running binning"
atlas run binning

echo "moving reports logs stats into metagenome dir"
mkdir files/
mv reports logs stats files/

echo "archiving metagenome dir"
# Create tar.gz archives for specific directories
for dir in */ ; do
    tar -czf "${dir%/}.tar.gz" "$dir"
done

#removing large files
rm *.fastq.gz
