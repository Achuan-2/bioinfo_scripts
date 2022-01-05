
#!/bin/bash
###################################################
### ==== NUMBER OF CPUS per TASK ====
#SBATCH --cpus-per-task=10
#SBATCH --mem=50G
#SBATCH -o slurm.%x.%j.out        # STDOUT
#SBATCH -e slurm.%x.%j.err        # STDERR
###########################



Project=/mnt/raid7/Dachuang/Achuan/visorter2/SBCM9_S165_L002/contig_level
ID=SBCM9_S165_L002
FQ=/mnt/raid7/wuyingjian/buffalo/02_removed_host/data1/${ID}/${ID}_paired_clean

cd ${Project}
mkdir -p NCLDV_bin
bwa index ./NCLDV.fa

# bwa men :alignment -> samtools view -> transform to bam -> samtools sort

bwa mem  ./NCLDV.fa ${FQ}1.fq ${FQ}2.fq -t 10 | samtools view -@ 10 -o NCLDV_contig.bam  -bS - 

samtools sort -o NCLDV_contig.sorted.bam -@ 10 NCLDV_contig.bam 

jgi_summarize_bam_contig_depths --outputDepth NCLDV_contig.depth.txt NCLDV_contig.sorted.bam

metabat2 -m 1500 -t 10 -i ./NCLDV.fa  -a NCLDV_contig.depth.txt -o NCLDV_bin/bin -v