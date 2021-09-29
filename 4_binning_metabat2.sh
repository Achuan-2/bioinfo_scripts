#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=50G
#SBATCH -o slurm.%j.out        # STDOUT
#SBATCH -e slurm.%j.err        # STDERR
source /mnt/raid1/wuyingjian/biosoft/miniconda/etc/profile.d/conda.sh
conda activate base

# usage : bash binning_bin3c.sh project_name whole_path_for_contigs whole_path_for_R1 whole_path_for_R2 enzyme
############### input ############
project_name=$1
path_for_contigs=$2
path_for_R1=$3
path_for_R2=$4

mkdir -p 04_binning/"$project_name"/metabat2
ln -s "$path_for_contigs" 04_binning/"$project_name"/metabat2/contigs.fasta
ln -s "$path_for_R1" 04_binning/"$project_name"/metabat2/"$project_name"_R1.fq
ln -s "$path_for_R2" 04_binning/"$project_name"/metabat2/"$project_name"_R2.fq

cd 04_binning/"$project_name"/metabat2

# build index
bwa index ./contigs.fasta
bwa mem -5SP contigs.fasta "$project_name"_R1.fq "$project_name"_R2.fq -t 10  | samtools view -F 0x904 -bS -@ 10  -  | samtools sort -o sample.sort.bam -@ 10  -

sh /mnt/raid1/wuyingjian/biosoft/metabat2/berkeleylab-metabat/runMetaBat.sh ./contigs.fasta ./sample.sort.bam
