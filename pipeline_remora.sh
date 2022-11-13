'''
Author: Shloka Negi, shnegi@ucsc.edu
Usage: Execute line by line, or blocks of code as required
Purpose: Pipeline to detect DNA mods (mC or hmC or both) using Guppy Basecaller with Remora mode
Input file requirements: fast5 files (here, I have T2T-CHM13 subset fast5 files for chrX)
Conda environments: /public/home/shnegi/.conda/envs/DNAmod
                  : /public/home/shnegi/.conda/envs/DNAmod/envs/modbam2bed

'''

source /opt/miniconda/etc/profile.d/conda.sh
conda activate /public/home/shnegi/.conda/envs/DNAmod

#1. Run Guppy with Remora
# SINGLE Mode (5mC only) - dna_r9.4.1_450bps_modbases_5mc_cg_sup_prom.cfg
guppy_basecaller \
   -i /public/groups/migalab/shnegi/CHM13_unmapped_fast5/subset/ \
   -s /public/groups/migalab/shnegi/CHM13_unmapped_fast5/remora_output_single/ \
   -c /opt/ont/guppy/data/dna_r9.4.1_450bps_modbases_5mc_cg_sup_prom.cfg \
   --bam_out \
   -x cuda:0,1,2,3 \
   -r \
   --read_batch_size 250000 \
   -q 250000

# DUAL Mode (5mC and 5hmC both) - dna_r9.4.1_450bps_modbases_5hmc_5mc_cg_sup_prom.cfg
guppy_basecaller \
   -i /public/groups/migalab/shnegi/CHM13_unmapped_fast5/subset/ \
   -s /public/groups/migalab/shnegi/CHM13_unmapped_fast5/remora_output_dual/ \
   -c /opt/ont/guppy/data/dna_r9.4.1_450bps_modbases_5hmc_5mc_cg_sup_prom.cfg \
   --bam_out \
   -x cuda:0,1,2,3 \
   -r \
   --read_batch_size 250000 \
   -q 250000


#2. Merge all BAM files
samtools merge merged_bam_single.bam *.bam
samtools merge merged_bam_dual.bam *.bam


#3. Convert aligned merged BAM file (with mods) into BED file
conda activate /public/home/shnegi/.conda/envs/DNAmod/envs/modbam2bed

# for CHM13 - mC mods from both SINGLE and DUAL modes
modbam2bed \
    -e -m 5mC --cpg -t 10 \
    chrX.fa \
    ./dual_mode/merged_bam_dual.fastq.cpg.chm13_chrX.bam > CHM13_dual.bed
modbam2bed \
    -e -m 5mC --cpg -t 10 \
    chrX.fa \
    ./single_mode/merged_bam_single.fastq.cpg.chm13_chrX.bam > CHM13_single.bed


#4. Extracting high confidence DNA mods
# Setting filtering threshold to 90%
cat CHM13_single.bed | awk '{ if ($11 >= 90) print $0 }' > CHM13_single_highconf.bed
cat CHM13_dual.bed | awk '{ if ($11 >= 90) print $0 }' > CHM13_dual_highconf.bed


#5. For detecting only 5hmC mods
modbam2bed \
    -e -m 5hmC --cpg -t 10 \
    chrX.fa \
    ./dual_mode/merged_bam_dual.fastq.cpg.chm13_chrX.bam > CHM13_chrX_guppy.5hmC.cpg.bed

## For 5hmC mods, setting filtering threshold to 90% - in CHM13
cat CHM13_chrX_guppy.5hmC.cpg.bed | awk '{ if ($11 >= 90) print $0 }' > chrX_guppy.5hmC.cpg_highconf.bed
