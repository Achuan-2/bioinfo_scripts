#!/bin/bash

###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH -o slurm.%N.%j.%x.out        # STDOUT
#SBATCH -e slurm.%N.%j.%x.err        # STDERR

# settings
ID=$1
HOST=/mnt/raid7/wangteng/buffalo/cattle/bwa_mapping/host_genomes/database/all_contamination_ref.db
PROJECT_HOME=/mnt/raid7/Dachuang/Achuan # project folder
DATA=${PROJECT_HOME}/01_cleandata/${ID}/${ID}
RESULT=${PROJECT_HOME}/02_removed_host/${ID}/${ID}

# run
mkdir -p 02_removed_host/${ID}/

bowtie2 -x ${HOST} -p 10  --very-sensitive \
    -1 ${DATA}_clean_R1.fq \
    -2 ${DATA}_clean_R2.fq \
    --un-conc ${RESULT}_paired_clean%.fq \
    --al-conc ${RESULT}_paired_contam%.fq

# bowtie2 -x /mnt/raid6/wangteng/buffalo/Representative_genome/databases/all_contamination_ref/all_contamination_ref.db -p 10 --very-sensitive -U /mnt/raid6/wangteng/buffalo/data11/analysis/01_cleandata/${ID}/${ID}_clean_unpaired_R1.fq --un 02_removed_host/${ID}/${ID}_single_clean1.fq --al 02_removed_host/${ID}/${ID}_single_contam1.fq
# bowtie2 -x /mnt/raid6/wangteng/buffalo/Representative_genome/databases/all_contamination_ref/all_contamination_ref.db -p 10 --very-sensitive -U /mnt/raid6/wangteng/buffalo/data11/analysis/01_cleandata/${ID}/${ID}_clean_unpaired_R2.fq --un 02_removed_host/${ID}/${ID}_single_clean2.fq --al 02_removed_host/${ID}/${ID}_single_contam2.fq


