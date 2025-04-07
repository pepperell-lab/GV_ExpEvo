#!/bin/bash
#Usage: snpEff.sh <_withAnnot.csv>

# Run R script to generate VCF file from CSV input
Rscript ~/scripts/poolER/csvToVCF.R $1

# Use the output file of the R script as input for the Java script
# Assuming $f contains a filename with .csv extension
f_without_extension="${1%.csv}"
java -Xmx8g -jar /opt/PepPrograms/snpEff_v5.0/snpEff.jar GV_14018 "${f_without_extension}.vcf" > snpEff.tsv


#run R script to combine 
Rscript ~/scripts/poolER/combine.R $1
