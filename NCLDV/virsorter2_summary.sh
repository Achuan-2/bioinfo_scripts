#!/bin/bash
######usage####
# bash /mnt/raid7/Dachuang/Achuan/scripts/viralrecall_summary.sh $DATA
###########
DATA=$1
HOME=/mnt/raid7/Dachuang/Achuan/02_is_NCLDV/virsorter_result
Project=/mnt/raid7/Dachuang/Achuan/02_is_NCLDV/virsorter_result/${DATA}

ls ${Project}> ${HOME}/${DATA}_id.txt

> ${HOME}/${DATA}_contig_sum.txt
for ID in `cat ${HOME}/${DATA}_id.txt`;do 
grep ">"  /mnt/raid7/wuyingjian/buffalo/03_assembly_megahit/${DATA}/${ID}/final.contigs.fa | wc -l >> ${HOME}/${DATA}_contig_sum.txt
done

> ${HOME}/${DATA}_NCLDV_sum.txt
for ID in `cat ${HOME}/${DATA}_id.txt`;do 
grep ">"  ${Project}/${ID}/final-viral-combined.fa | wc -l >> ${HOME}/${DATA}_NCLDV_sum.txt
done


# 先合并sample id、contig num、NCLDV num
paste ${HOME}/${DATA}_id.txt ${HOME}/${DATA}_contig_sum.txt ${HOME}/${DATA}_NCLDV_sum.txt > ${HOME}/${DATA}_info_tmp.txt

# 计算得率到最后一列
paste ${HOME}/${DATA}_info_tmp.txt <(awk '{print $3/$2}' ${HOME}/${DATA}_info_tmp.txt) > ${HOME}/${DATA}_info.txt

#在第一行添加列信息
sed -i '1i\Id\tAll_contig_num\tNCLDV_contig_num\tRecover_rate' ${HOME}/${DATA}_info.txt

# 删除中间文件
rm ${HOME}/${DATA}_id.txt ${HOME}/${DATA}_contig_sum.txt ${HOME}/${DATA}_NCLDV_sum.txt ${HOME}/${DATA}_info_tmp.txt