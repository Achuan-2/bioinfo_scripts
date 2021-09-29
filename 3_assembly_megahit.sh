#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=30G
#SBATCH -o slurm.%x.%j.out        # STDOUT
#SBATCH -e slurm.%x.%j.err        # STDERR

source /mnt/raid1/wuyingjian/biosoft/miniconda/etc/profile.d/conda.sh
conda activate base

ID=$1

echo "dealing with ${ID}"
PROJECT_HOME=/mnt/raid7/Dachuang/Achuan
pwd_path=`pwd`
removed_host=${PROJECT_HOME}/02_removed_host
contig_path=${PROJECT_HOME}/03_assembly_megahit
RESULT=${contig_path}/${ID}/${ID}

mkdir -p ${contig_path}

megahit -t 10 --min-contig-len 1000 \
        --k-list 27,37,47,57,67,77,87 \
        --kmin-1pass -m 60e+10 
        -1 ${RESULT}_paired_clean1.fq \
        -2 ${RESULT}_paired_clean2.fq \
        -o ${contig_path}/${ID}
        --out-prefix ${ID}



