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
MEGAHIT_OUTPUT=${PROJECT_HOME}/03_assembly_megahit
MEGAHIT_CONTIG=${MEGAHIT_OUTPUT}/${ID}/final.contigs.fa
MEGAHIT_REPORT=${PROJECT_HOME}/03_assembly_report/megahit


mkdir -p ${MEGAHIT_REPORT}


######## run quast.py ########

quast.py ${MEGAHIT_CONTIG} -o ${MEGAHIT_REPORT}/${ID}



