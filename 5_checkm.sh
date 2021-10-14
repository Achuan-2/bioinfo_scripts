#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=15
#SBATCH --mem=30G
#SBATCH -o slurm.%x.%j.out        # STDOUT
#SBATCH -e slurm.%x.%j.err        # STDERR

######################### input####################



# settings，ERR2027889
ID=$1
PROJECT_HOME=/mnt/raid7/Dachuang/Achuan
BINNING_PATH=${PROJECT_HOME}/04_binning/${ID}/bins_dir
OUTPUT=${PROJECT_HOME}/05_checkm/${ID}

mkdir -p ${OUTPUT}


# dependency
export PATH=$PATH:'/mnt/raid7/Dachuang/Achuan/biosoft/hmmer/bin'
export PATH=$PATH:'/mnt/raid7/Dachuang/Achuan/biosoft/Prodigal-2.6.3'
export PATH=$PATH:'/mnt/raid7/Dachuang/Achuan/biosoft/pplacer-Linux-v1.1.alpha19'


# run checkm
# checkm lineage_wf -t 20 -x fa --nt --tab_table -f bins_qa.txt bin_dir output_dir
# -x指定bins文件的拓展名
# --tab_table结果文件中表格形式的结果以tab分隔
# --nt输出每一个bin中的基因序列（调用prodigal软件进行预测）
# -f bins_qa.txt 将默认输出到标准输出的评估结果储存到指定结果文件
# bin_dir 输入文件夹
checkm lineage_wf -t 20 -x fa --nt --tab_table -f bins_qa.txt ${BINNING_PATH}  ${OUTPUT}  