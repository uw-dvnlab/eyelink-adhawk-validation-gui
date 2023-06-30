# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 13:17:27 2023

@author: azafar
"""
import pandas as pd
import plotly.io as pio
from bland_altman import bland_altman_plot

pio.renderers.default = "browser"

task = 'vms'
eye = None
dict_task = {'hms': ['Horizontal', 17.5],
             'vms': ['Vertical', 10]}
df_raw = pd.read_csv(f'./saccades/{task}/{task}_data.csv', index_col=[0])
df_el = df_raw.loc[df_raw.tracker=='EL']
df_ah = df_raw.loc[df_raw.tracker=='ML']
if eye:
    df_el = df_el.loc[df_el.eye==eye]
    df_ah = df_ah.loc[df_ah.eye==eye]

fig = bland_altman_plot(
    data1=df_el.amp.values,
    data2=df_ah.amp.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_el.subject,
    plotly_template='none',
    annotation_offset=1, 
    n_sd=1.96,
    parameter=f"{dict_task[task][0]} Saccade Amplitude",
    units='dva',
    range_x=[-1*dict_task[task][1], dict_task[task][1]],
    range_y=[-1*dict_task[task][1], dict_task[task][1]],
    marker_sz=10
    )

fig.show()