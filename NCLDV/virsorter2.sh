#!/bin/bash

###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH -o slurm.%N.%j.%x.out        # STDOUT
#SBATCH -e slurm.%N.%j.%x.err        # STDERR


conda activate achuan

ID=$1
Data=data14
Project=/mnt/raid7/Dachuang/Achuan/02_is_NCLDV/virsorter_result/${Data}


virsorter run -w ${Project}/${ID} \
    -i /mnt/raid7/wuyingjian/buffalo/03_assembly_megahit/${Data}/${ID}/final.contigs.fa \
    --include-groups NCLDV \
    --min-length 5000  \
    --min-score 0.5 \
    -j 10 all
