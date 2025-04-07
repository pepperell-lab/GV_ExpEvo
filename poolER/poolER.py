##Script to run popoolation in a high-throughput manner. Written by Mohamed Mohamed & Madeline Topf

import sys
import re
import subprocess
import csv

##Define arguments 
if len(sys.argv) != 4:
    print("Usage: poolER.py <csv file>  <Reference .fasta file> <Reference .bed file>")
    sys.exit()
    
filename = sys.argv[1]
referenceFasta = sys.argv[2]
referenceBed= sys.argv[3]
commands = []
namesOfTsvs = []

##use the csv file to read in filenames in order to run popoolation.sh 
with open(filename, 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        if row[0] != "ID":
            ancestor = row[1].strip() + ".ready.bam"
            passages = ""
            #need to filter out the the empty values here
            newrow = [i for i in row if i != ""]
            print(newrow)
            for x in range(2,len(row)):
                passages = passages + " " + row[x] + ".ready.bam"
            command = "bash poolER/run_popoolation.sh " + row[0] + " " + referenceFasta + " " + referenceBed + " " + ancestor + passages + "\n"
            namesOfTsvs.append(row[0] + ".tsv")
            commands.append(command)
for x in commands:
    subprocess.run(x.split(" "))


