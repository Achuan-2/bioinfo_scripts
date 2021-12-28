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
SPADES_REPORT=${PROJECT_HOME}/03_assembly_report/spades
SPADES_CONTIG=${PROJECT_HOME}/03_assembly_spades/${ID}/contigs.fasta

mkdir -p ${SPADES_REPORT}


######## run quast.py ########

quast.py ${SPADES_CONTIG} -o ${SPADES_REPORT}/${ID} --min-contig 1000



