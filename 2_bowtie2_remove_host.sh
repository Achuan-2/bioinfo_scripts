#!/bin/bash

###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH -o slurm.%N.%j.%x.out        # STDOUT
#SBATCH -e slurm.%N.%j.%x.err        # STDERR

source /mnt/raid1/wuyingjian/biosoft/miniconda/etc/profile.d/conda.sh
conda activate base

infile=$1

mkdir -p 02_removed_host/${infile}/

bowtie2 -x /mnt/raid1/wuyingjian/biosoft/database/human/hg38 -p 10 --very-sensitive -1 /mnt/raid7/wuyingjian/my_hic/internal_reference/01_cleandata/${infile}/${infile}_clean_R1.fq -2 /mnt/raid7/wuyingjian/my_hic/internal_reference/01_cleandata/${infile}/${infile}_clean_R2.fq --un-conc 02_removed_host/${infile}/${infile}_paired_clean%.fq --al-conc 02_removed_host/${infile}/${infile}_paired_contam%.fq

# bowtie2 -x /mnt/raid6/wangteng/buffalo/Representative_genome/databases/all_contamination_ref/all_contamination_ref.db -p 10 --very-sensitive -U /mnt/raid6/wangteng/buffalo/data11/analysis/01_cleandata/${infile}/${infile}_clean_unpaired_R1.fq --un 02_removed_host/${infile}/${infile}_single_clean1.fq --al 02_removed_host/${infile}/${infile}_single_contam1.fq
# bowtie2 -x /mnt/raid6/wangteng/buffalo/Representative_genome/databases/all_contamination_ref/all_contamination_ref.db -p 10 --very-sensitive -U /mnt/raid6/wangteng/buffalo/data11/analysis/01_cleandata/${infile}/${infile}_clean_unpaired_R2.fq --un 02_removed_host/${infile}/${infile}_single_clean2.fq --al 02_removed_host/${infile}/${infile}_single_contam2.fq


