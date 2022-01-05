#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=50G
#SBATCH -o slurm.%x.%j.out        # STDOUT
#SBATCH -e slurm.%x.%j.err        # STDERR
###########################


########### usage  ##########################
## local path ： /mnt/raid7/Dachuang/Achuan/scripts/viralrecall.sh
# cd /mnt/raid7/Dachuang/Achuan/02_is_NCLDV/
# ls /mnt/raid7/wuyingjian/buffalo/03_assembly_megahit/{DATA_set}/ | while read id;do sbatch /mnt/raid7/Dachuang/Achuan/scripts/virsorter2.sh ${id} data14;done
##########################




ID=$1
DATA=$2
BIN=/mnt/raid7/wuyingjian/buffalo/05_binning/${DATA}/${ID}/final.contigs.fa.metabat-bins10
PROJECT=/mnt/raid7/Dachuang/Achuan/02_is_NCLDV/viralrecall_result/${DATA}


cd /mnt/raid7/Dachuang/Achuan/02_is_NCLDV/viralrecall

python viralrecall.py -i ${BIN} -p ${PROJECT} -b -c -f -t 10
