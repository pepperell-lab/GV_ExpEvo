library(tidyverse)
library(readr)

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if an input file was provided
if (length(args) == 0) {
  stop("Please provide an input file name as a command-line argument.")
}

infile <- args[1]
csv <- read_csv(infile, col_types = cols(ref = col_character(), alt = col_character()))

csv <- csv %>% select(ID, ref, alt, pos)

colnames(csv) <- c("ID", "REF", "ALT", "POS")
csv$'#CHROM' <- "AP012332.1"
csv$FILTER <- "."
csv$INFO <- "."
csv$QUAL <- "."
csv$FORMAT <- "GT"
csv$Genome <- 1

##reorder the column names correctly
df <- csv[, c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT", "Genome")]

##write output file
outfile <- gsub(".csv", ".vcf", infile)
print(outfile)
write_tsv(df, outfile)

