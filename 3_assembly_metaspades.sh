#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G
#SBATCH -o slurm.%j.out        # STDOUT
#SBATCH -e slurm.%j.err        # STDERR
###################################################

ID=$1
echo "dealing with ${ID}"
PROJECT_HOME=/mnt/raid7/Dachuang/Achuan
REMOVED_HOST=${PROJECT_HOME}/02_removed_host
INPUT=${REMOVED_HOST}/${ID}/${ID}

#spades=/mnt/raid1/wuyingjian/biosoft/SPAdes-3.14.1/bin/spades.py
SPADES_OUT=${PROJECT_HOME}/03_assembly_spades
mkdir -p ${SPADES_OUT}/${ID}

spades.py --meta \
    -1 ${INPUT}_paired_clean1.fq \
    -2 ${INPUT}_paired_clean2.fq \
    -o ${SPADES_OUT}/${ID} -t 20  
