#!/bin/bash
DATA=$1
PROJECT=/mnt/raid7/Dachuang/Achuan/02_is_NCLDV/viralrecall_result

cd ${PROJECT}/
ls /mnt/raid7/wuyingjian/buffalo/05_binning/${DATA} > ${DATA}_id.txt


#查询data数据集每个样本有多少分箱
> ${DATA}_all_num.txt
cat ${DATA}_id.txt | while read ID;do
ls /mnt/raid7/wuyingjian/buffalo/05_binning/${DATA}/${ID}/final.contigs.fa.metabat-bins10| wc -l >> ${DATA}_all_num.txt;done

# 查询每个样本有多少NCLDV
> ${DATA}_NCLDV_num.txt
cat ${DATA}_id.txt | while read ID;do
    CSV=${DATA}/${ID}/infer_NCLDV.tsv
    if [ -f ${CSV} ] 
    then
    tail -n+2 ${CSV} | wc -l >> ${DATA}_NCLDV_num.txt

    else
    echo 0 >> ${DATA}_NCLDV_num.txt

    fi 
done

paste ${DATA}_id.txt ${DATA}_all_num.txt ${DATA}_NCLDV_num.txt >  ${DATA}_summary.tsv

#在第一行添加列信息
sed -i '1i\ID\tAll_Bin_Num\tInfer_NCLDV' ${DATA}_summary.tsv

rm ${DATA}_all_num.txt ${DATA}_NCLDV_num.txt ${DATA}_id.txt