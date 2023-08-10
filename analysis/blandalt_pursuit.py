# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 12:45:47 2023

@author: azafar
"""
import pandas as pd
import plotly.io as pio
from bland_altman import bland_altman_plot

pio.renderers.default = "browser"

#%% Create plot - Pursuit: Horizontal Gain
task = 'hsp'
thresh_coeff = 0.5
df_data = pd.read_csv(f'./smooth_pursuit/gains_{task}.csv')
df_data.drop(df_data[df_data.coeff_el < thresh_coeff].index, inplace=True)
df_data.drop(df_data[df_data.coeff_ah < thresh_coeff].index, inplace=True)

fig = bland_altman_plot(
    data1=df_data.gain_el.values,
    data2=df_data.gain_ah.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_data.freq, 
    plotly_template='none',
    annotation_offset=0.12, 
    n_sd=1.96,
    parameter="Horizontal Velocity Gain",
    units='ratio',
    range_x=[0, 2],
    range_y=[-2.5, 2.5],
    marker_sz=10)

fig.show()

#%% Create plot - Pursuit: Vertical Gain
task = 'vsp'
thresh_coeff = 0.5
df_data = pd.read_csv(f'./smooth_pursuit/gains_{task}.csv')
df_data.drop(df_data[df_data.coeff_el < thresh_coeff].index, inplace=True)
df_data.drop(df_data[df_data.coeff_ah < thresh_coeff].index, inplace=True)
df_data = df_data.loc[df_data.freq==0.01]

fig = bland_altman_plot(
    data1=df_data.slope_el.values,
    data2=df_data.slope_ah.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_data.subject, 
    plotly_template='none',
    annotation_offset=0.15, 
    n_sd=1.96,
    parameter="Vertical Velocity Gain",
    units='ratio',
    range_x=[0, 15],
    range_y=[-6, 6],
    marker_sz=10)

fig.show()