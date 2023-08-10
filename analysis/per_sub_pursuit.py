# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 23:27:37 2023

@author: azafar
"""

import pandas as pd
from per_subject import per_subject_plot
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

#%% Create plot - Pursuit: Velocity Gain
task = 'hsp' # 'hsp' or 'vsp'
thresh_coeff = 0.5
df_data = pd.read_csv(f'./smooth_pursuit/gains_{task}.csv')
df_data.drop(df_data[df_data.coeff_el < thresh_coeff].index, inplace=True)
df_data.drop(df_data[df_data.coeff_ah < thresh_coeff].index, inplace=True)
df_data.dropna(inplace=True)

df_data['diff'] = df_data.gain_el - df_data.gain_ah

df_all = df_data.copy()
df_all.subject = 'Mean'

df = pd.concat([df_data, df_all])
df.rename(columns={"freq": "Speed"}, inplace=True)
df.loc[df.Speed==0.01, 'Speed'] = r'0.5$^{\circ}$/s'
df.loc[df.Speed==0.1, 'Speed'] = r'5$^{\circ}$/s'
df.loc[df.Speed==0.2, 'Speed'] = r'10$^{\circ}$/s'

my_dpi = 96
plt.close('all')
plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)
plt.rcParams.update({'font.size': 30})

sns.pointplot(data=df, x='subject', y='diff', hue='Speed', join=False,
              dodge=0.5, errorbar='sd', capsize=.2, errwidth=2,
              hue_order=[r'0.5$^{\circ}$/s', '5$^{\circ}$/s', '10$^{\circ}$/s'],
              order=list(np.arange(1,14,1)) + [""] + ["Mean"])

plt.plot([-1, 15], [0,0], 'k')

plt.xlim(-1, 15)
plt.ylim(-2.25, 2.25)
plt.xlabel('Participant')
plt.ylabel('Velocity Gain Difference (ratio)')
plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),
          ncol=3, fancybox=True, shadow=True)

#%% Create plot - Pursuit: Velocity
task = 'hsp' # 'hsp' or 'vsp'
thresh_coeff = 0.5
df_data = pd.read_csv(f'./smooth_pursuit/gains_{task}.csv')
df_data.drop(df_data[df_data.coeff_el < thresh_coeff].index, inplace=True)
df_data.drop(df_data[df_data.coeff_ah < thresh_coeff].index, inplace=True)
df_data.dropna(inplace=True)

df_data['diff'] = df_data.slope_el - df_data.slope_ah

df_all = df_data.copy()
df_all.subject = 'Mean'

df = pd.concat([df_data, df_all])
df.rename(columns={"freq": "Speed"}, inplace=True)
df.loc[df.Speed==0.01, 'Speed'] = r'0.5$^{\circ}$/s'
df.loc[df.Speed==0.1, 'Speed'] = r'5$^{\circ}$/s'
df.loc[df.Speed==0.2, 'Speed'] = r'10$^{\circ}$/s'

my_dpi = 96
plt.close('all')
plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)
plt.rcParams.update({'font.size': 30})

sns.pointplot(data=df, x='subject', y='diff', hue='Speed', join=False,
              dodge=0.5, errorbar='sd', capsize=.2, errwidth=2,
              hue_order=[r'0.5$^{\circ}$/s', '5$^{\circ}$/s', '10$^{\circ}$/s'],
              order=list(np.arange(1,14,1)) + [""] + ["Mean"])

plt.plot([-1, 15], [0,0], 'k')

plt.xlim(-1, 15)
plt.ylim(-12, 12)
plt.xlabel('Participant')
plt.ylabel(r'Velocity Difference ($^{\circ}$/s)')
plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),
          ncol=3, fancybox=True, shadow=True)