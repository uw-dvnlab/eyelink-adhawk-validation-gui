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
    fig = plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)
    plt.rcParams.update({'font.size': 30})
    
    group_mean = df[y].mean()
    group_std = df[y].std()
    
    sub_mean = df.groupby([x]).mean().reset_index()
    sub_std = df.groupby([x]).std().reset_index()
    
    x_positions = list(np.arange(1,len(sub_mean)+1,1))
    mean_position = len(sub_mean)+1.5
    
    # print(x_positions)
    # print(sub_mean[y])
    
    plt.errorbar(x_positions, sub_mean[y].values, yerr=sub_std[y].values, color='k', fmt='o', lw=2,
                 dash_capstyle='round', capsize=5)
    plt.errorbar(mean_position, group_mean, yerr=group_std, color='k', fmt='o', lw=4,
                 dash_capstyle='round', capsize=10)
    
    plt.plot([-1, xlim+2], [0,0], 'k')
    
    plt.gca().set_xticks(x_positions + [mean_position])
    plt.gca().set_xticklabels(list(np.arange(1,xlim,1)) + ['Mean'])
    plt.xlim(0.5, xlim + 2)
    plt.ylim(ylim[0], ylim[1])
    plt.xlabel('Participant')
    plt.ylabel(ylabel)
    # plt.title(f'{title} Difference Per Subject')
    
    fig.tight_layout()