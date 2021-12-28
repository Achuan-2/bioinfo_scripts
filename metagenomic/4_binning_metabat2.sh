#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=50G
#SBATCH -o slurm.%x.%j.out        # STDOUT
#SBATCH -e slurm.%x.%j.err        # STDERR


# usage : bash binning_bin3c.sh project_name whole_path_for_contigs whole_path_for_R1 whole_path_for_R2 enzyme
############### input ############


# settings,ERR2027889
ID=$1
PROJECT_HOME=/mnt/raid7/Dachuang/Achuan
FASTA_PATH=${PROJECT_HOME}/02_removed_host/${ID}
CONTIG_PATH=${PROJECT_HOME}/03_assembly_megahit/${ID}/final.contigs.fa
BINNING_PATH=${PROJECT_HOME}/04_binning/${ID}
echo "dealing with ${ID}"

mkdir -p ${BINNING_PATH}

ln -s ${CONTIG_PATH} ${BINNING_PATH}/contigs.fa
ln -s ${FASTA_PATH}/${ID}_paired_clean1.fq  ${BINNING_PATH}/${ID}_R1.fq
ln -s ${FASTA_PATH}/${ID}_paired_clean2.fq  ${BINNING_PATH}/${ID}_R2.fq


cd ${BINNING_PATH}

# build index
bwa index ./contigs.fa

# bwa men :alignment -> samtools view -> transform to bam -> samtools sort

bwa mem  contigs.fa ${ID}_R1.fq ${ID}_R2.fq -t 10 | samtools view -@ 10 -o contig.bam  -bS - 

samtools sort -o contig.sorted.bam -@ 10 contig.bam 

jgi_summarize_bam_contig_depths --outputDepth contig.depth.txt contig.sorted.bam

metabat2 -m 1500 -t 10 -i ./contigs.fa  -a contig.depth.txt -o bins_dir/bin -v


