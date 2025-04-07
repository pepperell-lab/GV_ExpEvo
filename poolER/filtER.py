import csv
import sys
import subprocess
if len(sys.argv) < 3:
    print("Usage: filtER.py <tsv output from poolER '_popoolation.tsv'> <Reference bed> <filter %> <template.csv>")
    sys.exit()

##This script filters the allele trajectories that meet certain criteria

##define arguments
referenceBed = sys.argv[2]
tsv = sys.argv[1]
tsv_file = open(tsv)
read_tsv = csv.reader(tsv_file, delimiter="\t")
filename = tsv.replace('.tsv', "") + ".csv"

name = sys.argv[1].replace("_popoolation.tsv", "")
minimumFreq = sys.argv[3]
bedInfo = []
data = sys.argv[4]
passages = []
rowsToAdd = []

##open the .bed file
with open(referenceBed, 'r') as bedfile:
    reader = csv.reader(bedfile, delimiter='\t')
    for row in reader:
        if "header" not in row[0]:
            annot = row[9]
            print(annot)
            product =  annot
            tupleToAdd = (int(row[1]), int(row[2]), product)
            bedInfo.append(tupleToAdd)

##open the data.csv file containing the ID information and name the correct passage numbers
with open(data, 'r') as datafile: 
    read = csv.reader(datafile)
    for row in read:
        allnames = row[0]
        if allnames == name: ##here the name of the ID must match the correct name
            og_list = row[2:]
            new_list = []
            for item in og_list:
                if item:
                    item = item.split("_")[-1]
                    new_list.append(item)
            passagelist = [s[1:] for s in new_list]
            passagenums = [int(y) for y in passagelist]
            print("the passage numbers for " + str(name) + " are: " + str(passagenums))
        
with open(filename, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    for row in read_tsv:
        try:
            if (row[0] == "pos"):
                passages = row[3:]
                csvwriter.writerow(['ID'] + ['ref'] + ['alt'] + ['Anc'] + passagenums + ['pos'])
            elif ((abs(int(row[len(passages) + 2]) - int(row[3])) >= int(minimumFreq))):
                rowsToAdd.append(row)
        except:
            pass
        rowsToAddCopy = rowsToAdd.copy()
    
    for i, x in enumerate(rowsToAddCopy):
        thearray = x[1:]
        csvwriter.writerow([name] + thearray + [x[0]])


with open(tsv.replace(".tsv",".csv"), 'r') as file:
    reader_obj = csv.reader(file) #read the current csv file
    with open(tsv.replace(".tsv","") + "_withAnnot.csv", mode="w") as new_file:
        writer_obj = csv.writer(new_file) # Writes to the new CSV file 
        for row in reader_obj:
            if row[0] != "ID":
                lengthofRow = len(row)
                position = int(row[(lengthofRow-1)])
                # added a variable for the annotation
                annot = ""
                # search through bedInfo to find if this position is within an annotated gene
                for y in bedInfo:
                    if (y[0] <= position) and (position <= y[1]):
                        annot = y[2]
                # if no annotation has been found by searching through bedInfo (above), then the annotation is NA
                # ie if annot is still equal to "" and hasnt been set to a gene, set it instead to NA
                if annot == "":
                    annot = "NA"
                # whatever the annotation is, append it to the end of the row
                row.append(annot)
                # write the new row to the output file
                writer_obj.writerow(row)
            else:
                row.append("annot")
                writer_obj.writerow(row)

