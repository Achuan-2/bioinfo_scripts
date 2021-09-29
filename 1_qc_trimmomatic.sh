#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH -o slurm.trimmomatic.%j.out        # STDOUT 标准输入
#SBATCH -e slurm.trimmomatic.%j.err        # STDERR 标准错误
###################################################



########### input **********

# input setting
ID=$1 
PROJECT_HOME=/mnt/raid7/Dachuang/Achuan # project folder
RESULT=${PROJECT_HOME}/01_cleandata #output folder
DATA=${PROJECT_HOME}/data/train_data # data to clean
reads_for=${DATA}/${ID}/${ID}_1.fastq.gz   # forward read
reads_rev=${DATA}/${ID}/${ID}_2.fastq.gz  # backward read

# software setting
Trimmomatic=/mnt/raid1/wuyingjian/biosoft/Trimmomatic-0.39/trimmomatic-0.39.jar
adapter=/mnt/raid1/wuyingjian/biosoft/Trimmomatic-0.39/adapters


echo "dealing with ${ID}"

if [[ -s ${reads_for} ]] && [[ -s ${reads_rev} ]] ;then

## or jusr mkdir -p ${RESULT}/${ID}
if [ ! -d ${RESULT}/${ID} ];then
      mkdir -p ${RESULT}/${ID}
fi

java -jar ${Trimmomatic} PE -threads 10 \
      "$reads_for" \
      "$reads_rev" \
      ${RESULT}/${ID}/${ID}_clean_R1.fq ${RESULT}/${ID}/${ID}_clean_unpaired_R1.fq \
      ${RESULT}/${ID}/${ID}_clean_R2.fq ${RESULT}/${ID}/${ID}_clean_unpaired_R2.fq \
      ILLUMINACLIP:${adapter}/TruSeq3-PE.fa:2:30:15:1:true \
      LEADING:3 \
      SLIDINGWINDOW:4:15 \
      MINLEN:25 TRAILING:3 # QC: Minlen LEADING SLIDINGWINDOW TRAILING AVGQUAL

fi
