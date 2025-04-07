library(tidyverse)
library(readr)

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if an input file was provided
if (length(args) == 0) {
  stop("Please provide an input file name as a command-line argument.")
}


infile <- args[1]

input <- read_csv(infile, col_types= cols(ref = col_character(), alt= col_character()))

df <- read_tsv("snpEff.tsv", skip= 5)

keep <- df %>% select('#CHROM', POS, ID, REF, ALT, INFO)
names(keep)[names(keep) == "POS"] <- "pos"
names(keep)[names(keep) == "REF"] <- "ref"
names(keep)[names(keep) == "ALT"] <- "alt"


final <- left_join(keep, input, by= c("ID", "pos", "ref", "alt"))
outfile <- gsub("_withAnnot.csv", "_snpEff.csv", infile)
write_csv(final, outfile)
