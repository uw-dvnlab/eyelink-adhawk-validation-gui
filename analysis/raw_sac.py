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

my_dpi = 96
plt.close('all')
plt.rcParams.update({'font.size': 20})
fig, axes = plt.subplots(1, len(trackers),
                         figsize=(1600/my_dpi, 700/my_dpi), dpi=my_dpi,
                         sharey=True, sharex=True)

n_idx = 0
for j, track in enumerate(trackers):
    df = pd.read_excel(f'./saccades/raw_data/{track}_hms.xlsx')
    
    ax = axes[j]
    ax.text(-0.1, 1.02, f'({string.ascii_uppercase[n_idx].lower()})', transform=ax.transAxes, 
            size=24, weight='bold')
    
    fs = 250
    time = np.linspace(1, len(df), len(df)) / fs
    ax.plot(time, df.r, 'r', label='right eye')
    ax.plot(time, df.l, 'b', label='left eye')
    
    ax.set_xlabel('Time (sec)')
    ax.set_ylabel(f'{track.upper()} Position (DVA)')
    ax.set_ylim(-12.5, 9)
    # ax.legend()
    
    n_idx += 1
        
plt.suptitle('Raw Saccade Data')
handles, labels = ax.get_legend_handles_labels()
fig.legend(handles, labels, loc='upper right')