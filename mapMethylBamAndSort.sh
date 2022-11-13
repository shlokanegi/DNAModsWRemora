'''
Author: Monika Cechova, mcechova@ucsc.edu
Script based on the wdl file by Melissa Meredith - #https://github.com/meredith705/ont_methylation/blob/32095600428d21bf53aef8a7ccc401b0f10a9145/tasks/minimap2.wdl
Tweaked by: Shloka Negi, shnegi@ucsc.edu
Usage: ./mapMethylBamAndSort.sh
Purpose: Alignment and sorting of unmapped BAM files with DNAmod tags
Input file requirement: Unmapped merged BAM file with DNA mods information (in the form of MM and ML tags)

'''

#!/bin/bash

set -x
set -e

source /opt/miniconda/etc/profile.d/conda.sh;
conda activate /public/home/mcechova/conda/methylation/

unaligned_methyl_bam="merged_bam_dual.bam"          # or "merged_bam_single.bam" (Give input file here)
DIR="$(dirname "${unaligned_methyl_bam}")"          # output in the same directory where the input file is

in_cores=100                                        # number of processors to be used
in_args="-y -x map-ont -a --eqx -k 17 -K 10g"       # minimap parameters appropriate for nanopore reads
ref_file="/public/groups/migalab/shnegi/chrX.fa"    # path to the reference genome, here CHM13_chrX was the reference
sample="$(basename ${unaligned_methyl_bam} .bam)"
ref_name="chm13_chrX"                               # name of reference genome


# Alignment and Sorting
samtools fastq -T MM,ML ${unaligned_methyl_bam} | minimap2 -t ${in_cores} ${in_args} ${ref_file} - | samtools view -@ ${in_cores} -bh - | samtools sort -@ ${in_cores} - > ${DIR}/${sample}.fastq.cpg.${ref_name}.bam
samtools index ${DIR}/${sample}.fastq.cpg.${ref_name}.bam