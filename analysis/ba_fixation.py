# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 13:54:19 2023

@author: azafar
"""
import pandas as pd
import plotly.io as pio
from bland_altman import bland_altman_plot

pio.renderers.default = "browser"

df_data = pd.read_csv('./fixation_stability/fixation_stability.csv')

df_rx = df_data.loc[:, ['subject', 'el_rx_sd', 'ah_rx_sd']]
df_lx = df_data.loc[:, ['subject', 'el_lx_sd', 'ah_lx_sd']]
df_ry = df_data.loc[:, ['subject', 'el_ry_sd', 'ah_ry_sd']]
df_ly = df_data.loc[:, ['subject', 'el_ly_sd', 'ah_ly_sd']]

df_rx.columns = ['subject', 'el_sd', 'ah_sd']
df_lx.columns = ['subject', 'el_sd', 'ah_sd']
df_ry.columns = ['subject', 'el_sd', 'ah_sd']
df_ly.columns = ['subject', 'el_sd', 'ah_sd']

df_x = pd.concat([df_rx, df_lx])
df_y = pd.concat([df_ry, df_ly])

#%%
fig = bland_altman_plot(
    data1=df_x.el_sd.values,
    data2=df_x.ah_sd.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_x.subject,
    plotly_template='none',
    annotation_offset=0.03, 
    n_sd=1.96,
    parameter = "Horizontal SD",
    units = 'DVA',
    range_x = [0, 0.6],
    range_y = [-0.5, 0.5],
    marker_sz=20
    )

fig.show()

#%%
fig = bland_altman_plot(
    data1=df_y.el_sd.values,
    data2=df_y.ah_sd.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_y.subject,
    plotly_template='none',
    annotation_offset=0.03, 
    n_sd=1.96,
    parameter = "Vertical SD",
    units = 'DVA',
    range_x = [0, 0.6],
    range_y = [-0.5, 0.5],
    marker_sz=20
    )

fig.show()