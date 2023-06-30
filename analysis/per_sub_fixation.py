# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 22:56:20 2023

@author: azafar
"""
import pandas as pd
from per_subject import per_subject_plot

df_data = pd.read_csv('./fixation_stability/fixation_stability.csv')

#%% X SD
df = df_data.copy()
df['diff_r'] = df.el_rx_sd - df.ah_rx_sd
df['diff_l'] = df.el_lx_sd - df.ah_lx_sd

df_r = df.loc[:, ['subject', 'diff_r']]
df_l = df.loc[:, ['subject', 'diff_l']]
df_r.columns = ['subject', 'diff']
df_l.columns = ['subject', 'diff']

df = pd.concat([df_r, df_l])

df_all = df.copy()
df_all.subject = 'Mean'

df = pd.concat([df, df_all])

per_subject_plot(df,
                 'subject',
                 'diff',
                 15,
                 [-1.25,1.25],
                 'Fixation SD Difference (dva)',
                 'Horizontal Fixation SD')

#%% Y SD
df = df_data.copy()
df['diff_r'] = df.el_ry_sd - df.ah_ry_sd
df['diff_l'] = df.el_ly_sd - df.ah_ly_sd

df_r = df.loc[:, ['subject', 'diff_r']]
df_l = df.loc[:, ['subject', 'diff_l']]
df_r.columns = ['subject', 'diff']
df_l.columns = ['subject', 'diff']

df = pd.concat([df_r, df_l])

df_all = df.copy()
df_all.subject = 'Mean'

df = pd.concat([df, df_all])

per_subject_plot(df,
                 'subject',
                 'diff',
                 15,
                 [-1.25,1.25],
                 'Fixation SD Difference (dva)',
                 'Vertical Fixation SD')

#%% logBCEA
import numpy as np

df = df_data.copy()
factor = np.pi * 2.291

df['el_r_bcea'] = np.log10(
    factor * (df.el_rx_sd * df.el_ry_sd) * np.sqrt(1 - df.el_rcorr**2))
df['el_l_bcea'] = np.log10(
    factor * (df.el_lx_sd * df.el_ly_sd) * np.sqrt(1 - df.el_lcorr**2))
df['ah_r_bcea'] = np.log10(
    factor * (df.ah_rx_sd * df.ah_ry_sd) * np.sqrt(1 - df.ah_rcorr**2))
df['ah_l_bcea'] = np.log10(
    factor * (df.ah_lx_sd * df.ah_ly_sd) * np.sqrt(1 - df.ah_lcorr**2))

df['diff_r'] = df.el_r_bcea - df.ah_r_bcea
df['diff_l'] = df.el_l_bcea - df.ah_l_bcea

df_r = df.loc[:, ['subject', 'diff_r']]
df_l = df.loc[:, ['subject', 'diff_l']]
df_r.columns = ['subject', 'diff']
df_l.columns = ['subject', 'diff']

df = pd.concat([df_r, df_l])

df_all = df.copy()
df_all.subject = 'Mean'

df = pd.concat([df, df_all])

per_subject_plot(df,
                 'subject',
                 'diff',
                 15,
                 [-1.25,1.25],
                 'logBCEA Difference (dva^2)',
                 'logBCEA')