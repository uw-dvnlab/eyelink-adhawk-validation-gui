# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 23:06:36 2023

@author: azafar
"""
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

def per_subject_plot(df, x, y, xlim, ylim, ylabel, title):
    my_dpi = 96
    plt.close('all')
    plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)
    plt.rcParams.update({'font.size': 22})
    
    sns.pointplot(data=df, x=x, y=y, join=False,
                  errorbar='sd', capsize=.2, errwidth=2)
    
    plt.plot([-1, xlim], [0,0], 'k')
    
    plt.gca().set_xticklabels(list(np.arange(1,xlim,1)) + ['Mean'])
    plt.xlim(-1, xlim)
    plt.ylim(ylim[0], ylim[1])
    plt.xlabel('Subject')
    plt.ylabel(ylabel)
    plt.title(f'{title} Difference Per Subject')