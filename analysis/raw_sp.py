# -*- coding: utf-8 -*-
"""
Created on Sat Jun 17 14:22:36 2023

@author: azafar
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import string

speeds = ['001', '010', '020']
trackers = ['el', 'ml']

my_dpi = 96
plt.close('all')
plt.rcParams.update({'font.size': 18})
fig, axes = plt.subplots(1, len(speeds),
                         figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi,
                         sharey=True, sharex=True)

n_idx = 0
for i, spd in enumerate(speeds):
    ax = axes[i]
    for j, track in enumerate(trackers):
        df = pd.read_excel(f'./smooth_pursuit/raw_data/{track}_{spd}.xlsx')
        df['avg'] = (df.l + df.r) / 2
        df.avg = df.avg.values - df.avg.values[0]
        
        ax.text(-0.1, 1.05, f'({string.ascii_uppercase[i].lower()})', transform=ax.transAxes, 
                size=20, weight='bold')
        
        fs = 250
        time = np.linspace(1, len(df), len(df)) / fs
        ax.plot(time, df.avg, label=track.upper(), lw=3)
        
        ax.set_xlabel('Time (sec)')
        ax.set_ylabel(f'Position (DVA)')
        ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),
                  ncol=2, fancybox=True, shadow=True)
        ax.set_ylim(-10,10)
        
        n_idx += 1
        
# plt.suptitle('Raw Smooth Pursuit Data')
# handles, labels = ax.get_legend_handles_labels()
# fig.legend(handles, labels, loc='upper right')
