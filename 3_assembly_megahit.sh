#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=30G
#SBATCH -o slurm.%x.%j.out        # STDOUT
#SBATCH -e slurm.%x.%j.err        # STDERR
###################################################

# settings
ID=$1
echo "dealing with ${ID}"
PROJECT_HOME=/mnt/raid7/Dachuang/Achuan
pwd_path=`pwd`
removed_host=${PROJECT_HOME}/02_removed_host
contig_path=${PROJECT_HOME}/03_assembly_megahit
INPUT=${removed_host}/${ID}/${ID}

mkdir -p ${contig_path}

# run megahit
megahit -t 10 --min-contig-len 1000 \
        --k-min 27 --k-max 127 --k-step 10 \
        --kmin-1pass \
        -1 ${INPUT}_paired_clean1.fq \
        -2 ${INPUT}_paired_clean2.fq \
        -o ${contig_path}/${ID} 


