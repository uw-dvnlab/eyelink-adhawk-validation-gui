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
fig, axes = plt.subplots(len(speeds), len(trackers),
                         figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi,
                         sharey=True, sharex=True)

n_idx = 0
for i, spd in enumerate(speeds):
    for j, track in enumerate(trackers):
        df = pd.read_excel(f'./smooth_pursuit/raw_data/{track}_{spd}.xlsx')
        
        ax = axes[i,j]
        ax.text(-0.1, 1.1, string.ascii_uppercase[n_idx], transform=ax.transAxes, 
                size=20, weight='bold')
        
        fs = 250
        time = np.linspace(1, len(df), len(df)) / fs
        ax.plot(time, df.r, 'r', label='right eye')
        ax.plot(time, df.l, 'b', label='left eye')
        
        ax.set_xlabel('Time (sec)')
        ax.set_ylabel(f'{track.upper()} Position (dva)')
        # ax.legend()
        
        n_idx += 1
        
plt.suptitle('Raw Smooth Pursuit Data')