#!/usr/bin/env python3

"""help
input：work_dir绝对路径
脚本： /mnt/raid7/Dachuang/Achuan/scripts/viralrecall_filter.py
功能：
viralrecall基于MAG水平筛选NCLDV，
1. 先统计每个bin的平均得分，
2. 根据cutoff值（暂定为1），大于cutoff的bin会在infer_NCLDV.tsv中;如果没有大于cutoff的bin，则没有infer_NCLDV.tsv这个文件
3. 大于cutoff的bin.fa也会移动到这个文件夹下
"""
"""usage
# 一个文件夹

python /mnt/raid7/Dachuang/Achuan/scripts/viralrecall_filter.py --i /mnt/raid7/Dachuang/Achuan/02_is_NCLDV/viralrecall/bins_out --b /mnt/raid7/Dachuang/Achuan/02_is_NCLDV/viralrecall/bins

## 多个文件夹
PROJECT=/mnt/raid7/Dachuang/Achuan/02_is_NCLDV/viralrecall_result
DATA=data15
ls ${PROJECT}/${DATA} |while read id;do python viralrecall_filter.py --i ${PROJECT}/${DATA}/${ID} --b /mnt/raid7/wuyingjian/buffalo/05_binning/${DATA}/${ID}/final.contigs.fa.metabat-bins10;done
"""
import os
import pandas as pd
import argparse

# 0. 读取参数
# 创建一个ArgumentParser对象，以存储实参信息
description = """
功能：
viralrecall基于MAG水平筛选NCLDV，
1. 先统计每个bin的平均得分，contig数目，总长度，最大contig长度，最小contig长度
2. 根据cutoff值（暂定为1），大于cutoff的bin会在infer_NCLDV.tsv中;如果没有大于cutoff的bin，则没有infer_NCLDV.tsv这个文件
3. 大于cutoff的bin.fa也会移动到这个文件夹下
"""
parser = argparse.ArgumentParser(description=description)
# 方法add_argument()添加要解析的命令内容
parser.add_argument(
    '--i', type=str, help="input_dir: viralrecall result", required=True)
parser.add_argument('--b', type=str, help="origin_bin_dir", default=False)
args = parser.parse_args()  # 读入输入的参数，生成一个列表args
work_dir = args.i  # 接着对参数的任何操作，调用命名为xxx的参数方式为args.xxx
bin_dir = args.b


scores = []
bins = []
sum_lengths=[]
contig_nums=[]
max_contigs=[]
min_contigs=[]
# 1. 先统计每个bin的平均得分
for parent, dirnames, filenames in os.walk(work_dir):
    for dir in dirnames:
        table = pd.read_table(f"{work_dir}/{dir}/{dir}.summary.tsv")
        mean_score = table["score"].mean()
        sum_length = table["contig_length"].sum()
        contig_num = table.shape[0]
        max_contig = table["contig_length"].max()
        min_contig = table["contig_length"].min()
        scores.append(mean_score)
        sum_lengths.append(sum_length)
        contig_nums.append(contig_num)
        max_contigs.append(max_contig)
        min_contigs.append(min_contig)
        bins.append(dir)
summary_score = pd.DataFrame(
    {"bin": bins, "mean_score": scores, "sum_length": sum_lengths, "contig_num": contig_nums, "max_contig": max_contigs, "min_contig": min_contigs})
summary_score.to_csv(work_dir+"/summary_mean_score.tsv", sep="\t", index=False)

# 2. 根据cutoff值（暂定为1)进行筛选
cutoff = 1  # 可能会改为10？ 现在有点纠结要不要用-c命令，-c就是对每个contig都进行打分，有利于筛选嵌入到NCLDV中的
flag = sum(summary_score["mean_score"] > cutoff)


# 3. 大于cutoff的bin.fa会移动到viralrecall result下
if flag:
    infer_NCDLV = summary_score[summary_score["mean_score"] > 1]
    infer_NCDLV.to_csv(work_dir+"/infer_NCLDV.tsv", sep="\t", index=False)
    if bin_dir:
        for ID in infer_NCDLV["bin"]:
            os.system(f"ln -s {bin_dir}/{ID}.fa {work_dir}/{ID}.fa")
