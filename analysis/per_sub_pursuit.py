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

# HSP
task = 'hsp'
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
df.loc[df.Speed==0.01, 'Speed'] = '0.5 DVA/s'
df.loc[df.Speed==0.1, 'Speed'] = '5 DVA/s'
df.loc[df.Speed==0.2, 'Speed'] = '10 DVA/s'

my_dpi = 96
plt.close('all')
plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)
plt.rcParams.update({'font.size': 30})

sns.pointplot(data=df, x='subject', y='diff', hue='Speed', join=False,
              dodge=0.5, errorbar='sd', capsize=.2, errwidth=2,
              hue_order=['0.5 DVA/s', '5 DVA/s', '10 DVA/s'])

plt.plot([-1, 14], [0,0], 'k')

plt.gca().set_xticklabels(list(np.arange(1,14,1)) + ['Mean'])
plt.xlim(-1, 14)
plt.ylim(-2.5, 3.75)
plt.xlabel('Subject')
plt.ylabel('Velocity Gain Difference (ratio)')
plt.title('Horizontal Velocity Gain Difference Per Subject')

#%% Raw Vel
task = 'vsp'
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
df.loc[df.Speed==0.01, 'Speed'] = '0.5 DVA/s'
df.loc[df.Speed==0.1, 'Speed'] = '5 DVA/s'
df.loc[df.Speed==0.2, 'Speed'] = '10 DVA/s'

my_dpi = 96
plt.close('all')
plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)
plt.rcParams.update({'font.size': 30})

sns.pointplot(data=df, x='subject', y='diff', hue='Speed', join=False,
              dodge=0.5, errorbar='sd', capsize=.2, errwidth=2,
              hue_order=['0.5 DVA/s', '5 DVA/s', '10 DVA/s'])

plt.plot([-1, 14], [0,0], 'k')

plt.gca().set_xticklabels(list(np.arange(1,14,1)) + ['Mean'])
plt.xlim(-1, 14)
plt.ylim(-12, 12)
plt.xlabel('Subject')
plt.ylabel('Velocity Difference (DVA/s)')
plt.title('Vertical Velocity Difference Per Subject')