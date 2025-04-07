import sys
import os

if len(sys.argv) < 3:
    print("Usage: getGV_CAT.py <directory of text files> <classification genus/species> <output file>")
    sys.exit()

input_directory = sys.argv[1]
keyword = sys.argv[2]
output_file = sys.argv[3]

# Open the output file
with open(output_file, "w") as outfile:
    # Iterate over every file in the input directory
    for filename in os.listdir(input_directory):
        # Process only .txt files
        if filename.endswith(".txt"):
            file_path = os.path.join(input_directory, filename)

            # Open and read each file
            with open(file_path, "r") as infile:
                # Iterate through each line in the file
                for line in infile:
                    # Skip comment or header lines that start with '#'
                    if line.startswith("#"):
                        continue

                    # Split the line into fields using tab or spaces
                    fields = line.strip().split("\t")

                    # Check if the classification contains the keyword
                    if any(keyword.lower() in field.lower() for field in fields):
                        # Extract the bin name (first field) and write it to the output file
                        bin_name = fields[0]
                        outfile.write(f"{bin_name}\n")

print(f"Bins with '{keyword}' in the classification have been written to {output_file}.")
