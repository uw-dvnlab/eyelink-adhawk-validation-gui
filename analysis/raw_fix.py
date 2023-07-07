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

my_dpi = 96
plt.close('all')
plt.rcParams.update({'font.size': 18})
fig, axes = plt.subplots(len(direction), len(trackers),
                         figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi,
                         sharey=True, sharex=True)

n_idx = 0
for i, direct in enumerate(direction):
    for j, track in enumerate(trackers):
        df = pd.read_excel(f'./fixation_stability/raw_data/{track}_fix_{direct}.xlsx')
        
        ax = axes[i,j]
        ax.text(-0.1, 1.05, f'({string.ascii_uppercase[n_idx].lower()})', transform=ax.transAxes, 
                size=20, weight='bold')
        
        fs = 250
        time = np.linspace(1, len(df), len(df)) / fs
        ax.plot(time, df.r, 'r', label='right eye')
        ax.plot(time, df.l, 'b', label='left eye')
        
        if i==2:
            ax.set_xlabel('Time (sec)')
        ax.set_ylabel(f'{track.upper()} {direct.upper()} Position (DVA)')
        # ax.legend()
        ax.set_ylim(-1.25,1.25)
        
        n_idx += 1
        
plt.suptitle('Raw Fixation Data')
handles, labels = ax.get_legend_handles_labels()
fig.legend(handles, labels, loc='upper right')