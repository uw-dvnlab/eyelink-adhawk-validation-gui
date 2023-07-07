# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 18:38:35 2023

@author: azafar
"""
import pandas as pd
import numpy as np
import plotly.io as pio
from bland_altman import bland_altman_plot

pio.renderers.default = "browser"

df_data = pd.read_csv('./fixation_stability/fixation_stability.csv')

#%% compute logBCEA
factor = np.pi * 2.291

df_data['el_r_bcea'] = np.log10(
    factor * (df_data.el_rx_sd * df_data.el_ry_sd) * np.sqrt(1 - df_data.el_rcorr**2))
df_data['el_l_bcea'] = np.log10(
    factor * (df_data.el_lx_sd * df_data.el_ly_sd) * np.sqrt(1 - df_data.el_lcorr**2))
df_data['ah_r_bcea'] = np.log10(
    factor * (df_data.ah_rx_sd * df_data.ah_ry_sd) * np.sqrt(1 - df_data.ah_rcorr**2))
df_data['ah_l_bcea'] = np.log10(
    factor * (df_data.ah_lx_sd * df_data.ah_ly_sd) * np.sqrt(1 - df_data.ah_lcorr**2))

df_el_r = df_data.loc[:, ['subject', 'el_r_bcea']]
df_el_l = df_data.loc[:, ['subject', 'el_l_bcea']]
df_ah_r = df_data.loc[:, ['subject', 'ah_r_bcea']]
df_ah_l = df_data.loc[:, ['subject', 'ah_l_bcea']]

df_el_r.columns = ['subject', 'bcea']
df_el_l.columns = ['subject', 'bcea']
df_ah_r.columns = ['subject', 'bcea']
df_ah_l.columns = ['subject', 'bcea']

df_el = pd.concat([df_el_r, df_el_l])
df_ah = pd.concat([df_ah_r, df_ah_l])

#%%
fig = bland_altman_plot(
    data1=df_el.bcea.values,
    data2=df_ah.bcea.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_el.subject,
    plotly_template='none',
    annotation_offset=0.07, 
    n_sd=1.96,
    parameter = "logBCEA",
    units = 'DVA^2',
    range_x = [-2, 1],
    range_y = [-1.5, 1.5],
    marker_sz=20
    )

fig.show()