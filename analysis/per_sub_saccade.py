# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 23:47:42 2023

@author: azafar
"""

import pandas as pd
from per_subject import per_subject_plot

nsubs = 13
task = 'hms'
dict_task = {'hms': ['Horizontal', 17.5],
             'vms': ['Vertical', 10]}
for n in range(nsubs):
    num = "%02d" % (n+1,)
    df_sub = pd.read_csv(f'./saccades/{task}/AE{num}_{task.upper()}_export.csv')
    if n==0:
        df_data = df_sub.copy()
    else:
        df_data = pd.concat([df_data, df_sub.copy()])

# df_data.drop(df_data[df_data.EL_quality != 1].index, inplace=True)
# df_data.drop(df_data[df_data.AH_quality != 1].index, inplace=True)
df_data = df_data[["subject",
                   "EL_Right_P1_amp", "EL_Right_P1_vel",
                   "EL_Left_P1_amp", "EL_Left_P1_vel",
                   "AH_Right_P1_amp", "AH_Right_P1_vel",
                   "AH_Left_P1_amp", "AH_Left_P1_vel"]]
df_data.dropna(inplace=True)

amp_r_p1 = df_data.loc[:, ["subject", "EL_Right_P1_amp", "AH_Right_P1_amp"]]
amp_l_p1 = df_data.loc[:, ["subject", "EL_Left_P1_amp", "AH_Left_P1_amp"]]

amp_r_p1.columns = ['subject', 'el_amp', 'ah_amp']
amp_l_p1.columns = ['subject', 'el_amp', 'ah_amp']

amp_r = pd.concat([amp_r_p1])
amp_l = pd.concat([amp_l_p1])

df_amp = pd.concat([amp_r, amp_l])
df_amp['diff'] = df_amp.el_amp - df_amp.ah_amp

df_all = df_amp.copy()
df_all.subject = 'Mean'

df = pd.concat([df_amp, df_all])

per_subject_plot(df,
                 'subject',
                 'diff',
                 14,
                 [-15,15],
                 'Amplitude Difference (dva)',
                 f'{dict_task[task][0]} Saccade Amplitude')