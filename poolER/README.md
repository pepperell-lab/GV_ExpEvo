# Pooled evolve & re-sequence analysis
We conducted an evolve and re-sequence (ER) experiment with Gardnerella vaginalis. We passaged G. vaginalis strains with a selective pressure to grow as a biofilm. Next, we conducted whole-genome sequencing of pooled populations at intermediate passages over the course of the experiment. These scripts determine the genetic changes in bacterial populations over the course of passaging and annotate variants of interest. We used reference genome ATCC14018, here GV_14018.fasta and GV_14018.bed.

**poolER.py**

poolER runs popoolation (run_popoolation.sh) in a high throughput manner. poolER takes in a csv file of the file names and passage information formatted like template.csv, as well as a reference genome fasta and bed file. It outputs a .csv file of the frequency change at every position in the genome over passaging time. 

The path to run_popoolation.sh is hard-coded.

**filtER.py**

filtER takes in the output from poolER, the reference bed file, and the desired % frequency change. filtER first runs popoolationParser.py which filters the poolER output, leaving only variants which change in frequency => your desired %frequency change. Generally, we are interested in variants which change in frequency =>30%. 
Next, poolER annotates the variants using the reference bed file. In our case, we created the bed file using an annotator called prokka.

**findingConvergentHits.R**

This script will identify convergent hits across multiple experiments. 

Variants with high relative coverage that were invariant in the ancestor and rose to >85% frequency, were at a high starting frequency in the ancestor and disappeared from the population, or otherwise changed in frequency by >10% were isolated. This script creates a csv with each convergent gene variant and metadata.
