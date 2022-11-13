'''
Author: Shloka Negi, shnegi@ucsc.edu
Usage: Run line by line in RStudio
Purpose: Plotting probabilities (or difference of probabilities) of mC mod being present corresponding to a given position of Cytosine in a given read
Input column format required: 
["readID", "MM", "ML"] (Extracted from the final unmapped merged BAM file)
'''

# Pre-requisites to be followed - on Terminal

  #1. Take all the subset fast5 reads we have [meanwhile working with subsets from 30 partition files]
  #2. Run "guppy-basecaller" using both remora modes -- "single" & "dual"
  #3. Get all BAM files and merge them. Now we have 2 merged BAM files - one from each mode

# Plotting guidelines - on RStudio
  
  #1. Data pre-processing
  #2. Plotting line graph using ggplot

setwd("~/Desktop/migalab-Rotation/Scripts")                           # Set to working directory
load("~/Desktop/migalab-Rotation/Scripts/.RData")                     # Load .RData

# Installing required packages and Importing required libraries
library(readxl)
library(ggplot2)
library(dplyr)


# Importing Data
reads_MM_ML_single_sorted <- read.csv2("~/Desktop/migalab-Rotation/Scripts/reads_MM_ML_single_sorted.txt", header=FALSE, sep="")
reads_MM_ML_dual_sorted <- read.csv2("~/Desktop/migalab-Rotation/Scripts/reads_MM_ML_dual_sorted.txt", header=FALSE, sep="")

common_reads <- intersect(reads_MM_ML_single_sorted$V1, reads_MM_ML_dual_sorted$V1) 
# 48051 common reads

# Subsetting datasets to keep the common reads and ML columns
single <- reads_MM_ML_single_sorted[,c(1,3)] %>%
  filter(reads_MM_ML_single_sorted$V1 %in% common_reads)
dual <- reads_MM_ML_dual_sorted[,c(1,3)] %>%
  filter(reads_MM_ML_dual_sorted$V1 %in% common_reads)

# Split the ML column and prepare df for one read
i=1                                                                   # Any number (Each number corresponds to a different read)
ML_single <- unlist(strsplit(single$V3[i], split = ",", fixed = TRUE))[c(-1)] #All values are still chars
ML_dual <- unlist(strsplit(dual$V3[i], split = ",", fixed = TRUE))[c(-1)]
a = length(ML_single)+1
b = length(ML_dual)
ML_dual <- ML_dual[a:b]
df_to_use <- data.frame("mod_C" = c(seq(1:(a-1))), "prob_dual" = ML_dual, "prob_single" = ML_single)
df_to_use$prob_dual = as.numeric(df_to_use$prob_dual)
df_to_use$prob_single = as.numeric(df_to_use$prob_single)
# Convert 0 to 256 scale --> 0 to 1 scale
df_to_use$prob_single <- lapply(df_to_use$prob_single, function(x){x/256.0})
df_to_use$prob_dual <- lapply(df_to_use$prob_dual, function(x){x/256.0})
df_to_use$prob_dual = as.numeric(df_to_use$prob_dual)
df_to_use$prob_single = as.numeric(df_to_use$prob_single)

# Plotting
ggplot(data = df_to_use, aes(x=mod_C)) + 
  geom_line(aes(y = prob_dual, colour = "dual"), size = 1, lineend = "round") +
  geom_line(aes(y = prob_single, colour = "single"), size = 1, lineend = "round") +
  scale_color_manual(name = "remora_modes", values = c("dual" = "red", "single" = "darkblue")) +
  ggtitle("Comparison of 5mC mod probabilities between different remora modes for one read") +
  theme(plot.title = element_text(size = 15, face = "bold"), 
        legend.title = element_text(size=13, face = "bold"),
        legend.text = element_text(size=12), 
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.text.y = element_text(size = 12)) +
  labs(x = "modified Cytosines on read", y="Probability")

# Plot differences
# diff = ML_single - ML_dual

df_to_use <- cbind(df_to_use, "diff" = df_to_use$prob_single - df_to_use$prob_dual)
df_to_use <- df_to_use %>%
  mutate(pos = ifelse(diff>=0, "positive", "negative"))

ggplot(df_to_use, aes(x=mod_C, y=diff, fill=pos)) +
  geom_col(position = "identity", size = 0.25) +
  scale_fill_manual(name="sign", values=c("negative" = "red", "positive" = "darkgreen")) +
  ggtitle("Comparison of 5mC mod probabilities between different remora modes for one read") +
  theme(plot.title = element_text(size = 15, face = "bold"), 
        legend.title = element_text(size=13, face = "bold"),
        legend.text = element_text(size=12), 
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.text.y = element_text(size = 12)) +
  labs(x = "modified Cytosines on read", y="Difference of Probabilities (single - dual)")