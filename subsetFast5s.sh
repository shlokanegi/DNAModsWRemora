'''
Author: Shloka Negi, shnegi@ucsc.edu
Usage: ./subsetFast5s.sh
Purpose: Extracting fast5 reads by readIDs (Here, I have extracted fast5 reads that specifically map to chrX)
Input files requirements: 
   Path to all fast5s, 
   readIDs.txt file containing readIDs of reads to be extracted.

'''

### Subsetting chrX fast5 reads

#1. Change to the working dir
cd /public/groups/migalab/shnegi/CHM13_unmapped_fast5

#2. Find the "reads" directory within unzipped partition files (files after unzipping fast5s) and save all paths in a txt file
find . -type d -name "reads" > reads_path.txt

#3. Loop through all reads directories, get the fast5 subsets in "subset" directory.
c=0
for x in $(awk '{print $1}' reads_path.txt);
do

   c=$((c + 1))   #Needed for naming subsets uniquely in each iteration (each read path will generate a different subset file)

   echo "##Processing reads directory" $x "##";

   #Run subsetting command
   fast5_subset \
   --input $x \
   --save_path ./subset/'subset_'${c} \
   --read_id_list /data/shnegi/CHM13_aligned_noM/chrX_readIDs.txt \     # Path to txt file containing all chrX readIDs
   --recursive

   #Delete the partition file
   echo '## Deleting partition';

   rm -r $x

done