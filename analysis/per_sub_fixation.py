# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 22:56:20 2023

@author: azafar
"""
import pandas as pd
from per_subject import per_subject_plot

df_data = pd.read_csv('./fixation_stability/fixation_stability.csv')

#%% Create plot - Fixation: Horizontal SD
df = df_data.copy()
df['diff_r'] = df.el_rx_sd - df.ah_rx_sd
df['diff_l'] = df.el_lx_sd - df.ah_lx_sd

df_r = df.loc[:, ['subject', 'diff_r']]
df_l = df.loc[:, ['subject', 'diff_l']]
df_r.columns = ['subject', 'diff']
df_l.columns = ['subject', 'diff']

df = pd.concat([df_r, df_l])

per_subject_plot(df,
                 'subject',
                 'diff',
                 14,
                 [-0.6,0.6],
                 'Fixation SD Difference (degrees)',
                 'Horizontal Fixation SD')

#%% Create plot - Fixation: Vertical SD
df = df_data.copy()
df['diff_r'] = df.el_ry_sd - df.ah_ry_sd
df['diff_l'] = df.el_ly_sd - df.ah_ly_sd

df_r = df.loc[:, ['subject', 'diff_r']]
df_l = df.loc[:, ['subject', 'diff_l']]
df_r.columns = ['subject', 'diff']
df_l.columns = ['subject', 'diff']

df = pd.concat([df_r, df_l])

per_subject_plot(df,
                 'subject',
                 'diff',
                 14,
                 [-.6,.6],
                 'Fixation SD Difference (degrees)',
                 'Vertical Fixation SD')

#%% Create plot - Fixation: logBCEA
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

per_subject_plot(df,
                 'subject',
                 'diff',
                 14,
                 [-1.25,1.25],
                 r'log10BCEA Difference ($degrees^2$)',
                 'log10BCEA')