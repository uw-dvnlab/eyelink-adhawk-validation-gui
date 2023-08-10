# -*- coding: utf-8 -*-
"""
Created on Sat Jun 17 14:49:41 2023

@author: azafar
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import string

trackers = ['el', 'ml']
directions = ['hms', 'vms']
lbl=['Horizontal', 'Vertical']

my_dpi = 96
plt.close('all')
plt.rcParams.update({'font.size': 20})
fig, axes = plt.subplots(1, len(directions),
                         figsize=(1600/my_dpi, 700/my_dpi), dpi=my_dpi,
                         sharey=True, sharex=True)

n_idx = 0
for i, direction in enumerate(directions):
    ax = axes[i]
    for j, track in enumerate(trackers):
        df = pd.read_excel(f'./saccades/raw_data/{track}_{direction}_avg.xlsx')
        x = df.x.values - df.x.values[0]
        
        ax.text(-0.1, 1.02, f'({string.ascii_uppercase[i].lower()})', transform=ax.transAxes, 
                size=24, weight='bold')
        
        fs = 250
        time = np.linspace(1, len(df), len(df)) / fs
        ax.plot(time, x+0.25*j, label=track.upper(), lw=4)
        
        ax.set_xlabel('Time (sec)')
        ax.set_ylabel(f'Position (degrees)')
        ax.set_xlim(0, 2.75)
        ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.1),
                  ncol=2, fancybox=True, shadow=True)
        
        n_idx += 1
        
# plt.suptitle('Raw Saccade Data')
# handles, labels = ax.get_legend_handles_labels()
# fig.legend(handles, labels, loc='upper right')