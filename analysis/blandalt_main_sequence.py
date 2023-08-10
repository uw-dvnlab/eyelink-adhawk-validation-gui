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

#%% Create plot - Main Sequence
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
for n in range(1):
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
    plot_main_sequence( num, dict_data, dict_task[task][0] )
    dict_vmax['Subject'].append(f'AE{num}')
    dict_vmax['EL'].append(popt_el[0])
    dict_vmax['ML'].append(popt_ah[0])

df_vmax = pd.DataFrame().from_dict(dict_vmax)
df_vmax.to_csv(f'./saccades/{task}/vmax.csv')

#%% Create plot - Main Sequence: Peak Velocity Difference
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
    annotation_offset=45,
    n_sd=1.96,
    parameter = f"Max {dict_task[task][0]} Velocity",
    units = r'degrees/s',
    range_x = [200,750],
    range_y = [-1000, 1000],
    marker_sz=25,
    adjust=1.32)

fig.show()

#%% Create plot - Peak Saccade Velocity Bar Chart
import matplotlib.pyplot as plt

my_dpi = 96
plt.close('all')
plt.figure(figsize=(1600/my_dpi, 1000/my_dpi), dpi=my_dpi)
plt.rcParams.update({'font.size': 26})

df_blank = df_vmax.head(1).copy()
df_blank.Subject=''
df_blank.EL=0
df_blank.ML=0

df_mean = df_vmax.head(1).copy()
df_mean.Subject = 'Mean'
df_mean.EL = df_vmax.EL.mean()
df_mean.ML = df_vmax.ML.mean()

df = pd.concat([df_vmax, df_blank, df_mean])

df.plot(
    ax=plt.gca(),
    x='Subject',
    kind='bar',
    stacked=False,
    rot=0,
    width=0.75)

plt.gca().set_xticklabels(list(np.arange(1,14,1)) + ['', 'Mean'])
# plt.ylim(0,1000)
plt.xlabel('Participant')
plt.ylabel(r'Maximum Velocity ($^{\circ}$/s)')
# plt.title(f'Maximum Velocity from {dict_task[task][0]} Main Sequence')

    