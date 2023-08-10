# -*- coding: utf-8 -*-
"""
Created on Sun Jul  9 18:34:37 2023

@author: azafar
"""

# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 23:47:42 2023

@author: azafar
"""
import numpy as np
import pandas as pd
from per_subject import per_subject_plot

nsubs = 13
task = 'hms'
dict_task = {'hms': ['Horizontal', 17.5],
             'vms': ['Vertical', 10]}
for n in range(nsubs):
    num = "%02d" % (n+1,)
    df_sub = pd.read_csv(f'./saccades/{task}/AE{num}_{task.upper()}.csv')
    if n==0:
        df_data = df_sub.copy()
    else:
        df_data = pd.concat([df_data, df_sub.copy()])
df_data.reset_index(inplace=True)
#%% HMS: 1951/2275, VMS: 686/780, HSP/VSP: 680/780
df_data = df_data.drop(df_data[df_data['corr'] < 0.5].index)
df_data = df_data.drop(df_data[df_data['t_start_el'] > 1.5].index)
trials = df_data.drop_duplicates(subset=['subject', 'trial'])
#%%
# df_data.drop(df_data[df_data.AH_quality != 1].index, inplace=True)
df_data = df_data[["subject",
                   "amp_el", "amp_ah"]]
df_data.dropna(inplace=True)

df_amp = df_data.loc[:, ["subject", "amp_el", "amp_ah"]]
df_amp.columns = ['subject', 'el_amp', 'ah_amp']
df_amp['diff'] = df_amp.el_amp - df_amp.ah_amp

df_all = df_amp.copy()
df_all.subject = 'Mean'

df = pd.concat([df_amp, df_all])

per_subject_plot(df_amp,
                 'subject',
                 'diff',
                 14,
                 [-12,12],
                 'Amplitude Difference (degrees)',
                 f'{dict_task[task][0]} Saccade Amplitude')