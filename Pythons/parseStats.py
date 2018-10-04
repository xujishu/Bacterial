#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May  4 11:16:02 2018
we will merge a set of out idxstat outputs of samtools to build a count matrix
@author: jishuxu
"""
import pandas as pd
import glob
from os.path import basename

def parseStats(pathname,outputname):
    """
    """
    files = glob.glob(pathname+"*.stat")
    print(files)
    merged = pd.DataFrame()
    # loop through input files
    for kk in range(0, len(files)):
        fname = files[kk]
        exp_name = basename(fname)
        sample_name = exp_name.split('.')[0]
        print(sample_name)
        dat = pd.read_csv(
            fname,
            delimiter='\t',
            skiprows=1,
            sep='\t',
            names=[
                'ID', 'SeqLength', 'cnt', 'unmap'
                ],
            usecols=['ID', 'SeqLength', 'cnt'])
        dat.columns = ['ID','SeqLength',sample_name]
        if kk == 0:
            merged = dat
        else:
            cnt = dat
            merged = pd.merge(
                left=merged, right=cnt[['ID',sample_name]], left_on='ID', right_on='ID')
    merged.to_csv(outputname, index=False)
    return merged

    
    