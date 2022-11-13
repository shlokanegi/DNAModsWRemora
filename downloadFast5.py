'''
Author: Shloka Negi, shnegi@ucsc.edu
Usage: python3 downloadFast5.py
Purpose: Script to download all T2T-CHM13 nanopore long-read fast5 partition files
Conda environment: /public/home/shnegi/.conda/envs/DNAmod

'''

## Download fast5s without ranges
for i in range(0, 455):  # These ranges would have to be changed at times when the loop gives error on encountering a partition file with ranges
        s = str(i)
        while len(s) < 3:
            s = "0" + s
        url = "https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/nanopore/fast5/partition{}.tgz".format(s)
        response = wget.download(url)
        print ("{} file(s) has been donwloaded".format(i))
print("done")

## Download fast5s with ranges
l = ["partition145-148.tgz", "partition149-150.tgz", "partition151-152.tgz", 
"partition153-154.tgz", "partition155-156.tgz", "partition164-166.tgz", "partition167-168.tgz",
"partition169-171.tgz", "partition198-199.tgz", "partition200-201.tgz", "partition205-206.tgz", 
"partition209-210.tgz", "partition211-212.tgz", "partition219-220.tgz", "partition233-234.tgz"]
for i in l:
   url = "https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/nanopore/fast5/{}".format(i)
   response = wget.download(url)
print("done")
