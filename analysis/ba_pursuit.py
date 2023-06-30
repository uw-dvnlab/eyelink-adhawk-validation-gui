# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 12:45:47 2023

@author: azafar
"""
import pandas as pd
import plotly.io as pio
from bland_altman import bland_altman_plot

pio.renderers.default = "browser"

task = 'hsp'
thresh_coeff = 0.5
df_data = pd.read_csv(f'./smooth_pursuit/gains_{task}.csv')
df_data.drop(df_data[df_data.coeff_el < thresh_coeff].index, inplace=True)
df_data.drop(df_data[df_data.coeff_ah < thresh_coeff].index, inplace=True)

# print(1-(len(df_data)/2)/390)
df_data = df_data.loc[df_data.freq==0.1]

fig = bland_altman_plot(
    data1=df_data.gain_el.values,
    data2=df_data.gain_ah.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_data.subject, 
    plotly_template='none',
    annotation_offset=0.1, 
    n_sd=1.96,
    parameter="Horizontal Velocity Gain (5 dva/s)",
    units='ratio',
    range_x=[0, 1.5],
    range_y=[-2.5, 2.5],
    marker_sz=10)

fig.show()

#%%
task = 'vsp'
thresh_coeff = 0.9
df_data = pd.read_csv(f'./smooth_pursuit/gains_{task}.csv')
df_data.drop(df_data[df_data.coeff_el < thresh_coeff].index, inplace=True)
df_data.drop(df_data[df_data.coeff_ah < thresh_coeff].index, inplace=True)

fig = bland_altman_plot(
    data1=df_data.gain_el.values,
    data2=df_data.gain_ah.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_data.subject, 
    plotly_template='none',
    annotation_offset=0.05, 
    n_sd=1.96,
    parameter="Vertical Velocity Gain",
    units='ratio',
    range_x=[0, 1.5],
    range_y=[-1, 1],
    marker_sz=10)

fig.show()