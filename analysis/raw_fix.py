# -*- coding: utf-8 -*-
"""
Created on Sat Jun 17 14:49:41 2023

@author: azafar
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import string

direction = ['x', 'y']
trackers = ['el', 'ml']
lbl=['Horizontal', 'Vertical']

my_dpi = 96
plt.close('all')
plt.rcParams.update({'font.size': 18})
fig, axes = plt.subplots(1, len(direction),
                         figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi,
                         sharey=True, sharex=True)

n_idx = 0
for i, direct in enumerate(direction):
    ax = axes[i]
    ax.plot([0,2], [0,0], 'k:', lw=3)
    for j, track in enumerate(trackers):
        df = pd.read_excel(f'./fixation_stability/raw_data/{track}_fix_{direct}_avg.xlsx')
        
        ax.text(-0.1, 1.05, f'({string.ascii_uppercase[i].lower()})', transform=ax.transAxes, 
                size=20, weight='bold')
        
        fs = 250
        time = np.linspace(1, len(df), len(df)) / fs
        ax.plot(time, df.x, label=track.upper(), lw=3)
        
        ax.set_xlabel('Time (sec)')
        ax.set_ylabel(f'{lbl[i]} position (degrees)')
        ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),
                  ncol=2, fancybox=True, shadow=True)
        ax.set_ylim(-1,1)
        ax.set_xlim(0,2)
        
        n_idx += 1

