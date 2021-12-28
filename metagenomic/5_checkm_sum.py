#!/usr/bin/python
import numpy as np
import pandas as pd

import os
dir = '/mnt/raid7/Dachuang/Achuan/05_checkm'
samples = [dI for dI in os.listdir(dir) if os.path.isdir(os.path.join(dir, dI))]
# print(samples)

sum_table = pd.DataFrame(
    columns=["Sample", "Near", 'Substantially', 'Moderately'])
def summary(sample):
    global sum_table
    table = pd.read_csv(f"{sample}/bins_qa.txt", sep="\t")
    # near complete: > 90 % complete, < 10 % contanmination
    # substantially complete: > 70 % complete, < 10 % contamination
    # moderately complete: > 50 % complete, < 10 % contamination
    near = table[(table["Completeness"] >= 90) & (table["Contamination"] < 10)]
    substantially = table[(table["Completeness"] < 90) & (
        table["Completeness"] >= 70) & (table["Contamination"] < 10)]
    moderately = table[(table["Completeness"] < 70) & (
        table["Completeness"] >= 50) & (table["Contamination"] < 10)]

    # len可以知道一张表的行数
    near_num = len(near)

    substantially_num = len(substantially)
    moderately_num = len(moderately)
    # print(near_num, substantially_num, moderately_num)

    data = [{"Sample": sample, "Near": near_num,
             "Substantially": substantially_num, "Moderately": moderately_num}]
    row = pd.DataFrame(data)
    sum_table = sum_table.append(row, ignore_index=True)



for sample in samples:
    summary(sample)
sum_table.to_csv(
    f'/mnt/raid7/Dachuang/Achuan/05_checkm/summary.csv', index=None)
print(sum_table)
