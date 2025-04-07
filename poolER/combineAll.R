library(tidyverse)

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if an input file was provided
if (length(args) == 0) {
  stop("Please provide an input file name as a command-line argument.")
}


# Specify the directory containing CSV files
directory_path <- args[1]
  
# Get a list of all CSV files in the directory
csv_files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)
print(csv_files)

# Function to read and process each CSV file
read_and_process_csv <- function(file_path) {
  read_csv(file_path, col_types = cols())  # Adjust col_types if needed
}

# Map, read, and combine all CSV files into a single dataframe
combined_data <- map_dfr(csv_files, read_and_process_csv, .id = "file_id")

# Write the combined dataframe to a new CSV file
write_csv(combined_data, "combined_data.csv")
