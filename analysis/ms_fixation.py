# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 13:17:27 2023

@author: azafar
"""
import numpy as np
import pandas as pd
from scipy.optimize import curve_fit
from main_sequence import plot_main_sequence

task = 'hms'
eye = None
dict_task = {'hms': ['Horizontal', 17.5],
             'vms': ['Vertical', 10]}
df_raw = pd.read_csv(f'./saccades/{task}/{task}_data.csv', index_col=[0])
df_el = df_raw.loc[df_raw.tracker=='EL']
df_ah = df_raw.loc[df_raw.tracker=='ML']
if eye:
    df_el = df_el.loc[df_el.eye==eye]
    df_ah = df_ah.loc[df_ah.eye==eye]

df_el.amp = np.abs(df_el.amp)
df_ah.amp = np.abs(df_ah.amp)

#%%
def exp_func(t, popt):
    return popt[0] * (1 - np.exp(-1 * t / popt[1]))

def get_exp_curve(popt):
    max_amp = 35
    min_amp = 2
    
    x_fit = np.linspace(min_amp, max_amp, 100)
    y_fit = exp_func(x_fit, popt)
    
    return x_fit, y_fit

nsubs = 13
loss ='cauchy'
dict_vmax = { 'Subject': [], 'EL': [], 'ML': [] }
for n in range(nsubs):
    num = "%02d" % (n+1)
    df_el_sub = df_el.loc[df_el.subject==f'AE{num}', :]
    df_ah_sub = df_ah.loc[df_ah.subject==f'AE{num}', :]
    
    popt_el, _ = curve_fit(lambda x, a, b: a * (1 - np.exp(-1 * x / b)),
                           xdata=df_el_sub.amp,
                           ydata=df_el_sub.vel,
                           p0=[500, 1],
                           bounds=(
                               (0, -np.inf),
                               (2000, np.inf)),
                           method='trf',
                           loss=loss
                           )
    popt_ah, _ = curve_fit(lambda x, a, b: a * (1 - np.exp(-1 * x / b)),
                           xdata=df_ah_sub.amp,
                           ydata=df_ah_sub.vel,
                           p0=[500, 1],
                           bounds=(
                               (0, -np.inf),
                               (2000, np.inf)),
                           method='trf',
                           loss=loss
                           )
    
    fit_el_x, fit_el_y = get_exp_curve(popt_el)
    fit_ah_x, fit_ah_y = get_exp_curve(popt_ah)
    
    dict_data={
        'raw': [[df_el_sub.amp, df_el_sub.vel],
                [df_ah_sub.amp, df_ah_sub.vel]],
        'fit': [[fit_el_x, fit_el_y],
                [fit_ah_x, fit_ah_y]],
        'asymp': [popt_el[0],
                  popt_ah[0]],
        'color': ['tab:blue',
                  'tab:orange'],
        'label': ['EL',
                  'ML']
        }
    plot_main_sequence( num, dict_data )
    dict_vmax['Subject'].append(f'AE{num}')
    dict_vmax['EL'].append(popt_el[0])
    dict_vmax['ML'].append(popt_ah[0])

df_vmax = pd.DataFrame().from_dict(dict_vmax)
df_vmax.to_csv(f'./saccades/{task}/vmax.csv')

#%% Bland Altman
import plotly.io as pio
from bland_altman import bland_altman_plot

pio.renderers.default = "browser"

fig = bland_altman_plot(
    data1=df_vmax.EL.values,
    data2=df_vmax.ML.values,
    data1_name='EL', 
    data2_name='ML',
    subgroups=df_vmax.Subject,
    plotly_template='none',
    annotation_offset=30,
    n_sd=1.96,
    parameter = f"Max {dict_task[task][0]} Saccade Velocity",
    units = 'dva/s',
    range_x = [200,1000],
    range_y = [-1000, 1000],
    marker_sz=25)

fig.show()

#%% Bar plot
import matplotlib.pyplot as plt

my_dpi = 96
plt.close('all')
plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)

df_vmax.loc[nsubs] = df_vmax.mean()
df_vmax.at[nsubs, 'Subject'] = 'Mean'

df_vmax.plot(
    ax=plt.gca(),
    x='Subject',
    kind='bar',
    stacked=False,
    rot=0,
    width=0.75)

# plt.gca().set_xticklabels(np.arange(1,14,1))
# plt.ylim(0,1000)
plt.ylabel('Maximum Velocity (dva/s)')
plt.title(f'Maximum Velocity from {dict_task[task][0]} Main Sequence')

    