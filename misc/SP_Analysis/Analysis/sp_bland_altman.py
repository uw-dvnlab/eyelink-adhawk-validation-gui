# -*- coding: utf-8 -*-
"""
Created on Mon Mar 13 19:43:01 2023

@author: zafar
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def bland_altman_plot(axes, data1, data2, col='k', mark='o'=, *args, **kwargs):
    data1     = np.asarray(data1)
    data2     = np.asarray(data2)
    mean      = np.mean([data1, data2], axis=0)
    diff      = data1 - data2                   # Difference between data1 and data2
    md        = np.mean(diff)                   # Mean of the difference
    sd        = np.std(diff, axis=0)            # Standard deviation of the difference

    axes.scatter(mean, diff, color=col, marker=mark, *args, **kwargs)
    axes.axhline(md,           color=col, linestyle='--')
    axes.axhline(md + 1.96*sd, color=col, linestyle='--')
    axes.axhline(md - 1.96*sd, color=col, linestyle='--')
    
    return md, [md-1.96*sd, md+1.96*sd]


#%% READ DATA
TASK="hsp"
THRESH_COEFF = 0.9
EYES = ["left", "right"]
SPEEDS = [0.01, 0.1, 0.2]
COL = ['r', 'g', 'b']
MARK = ['o', '*', 'x']

df_data = pd.read_csv(f'./export/gains_{TASK}.csv')
df_data.dropna(subset=['coeff_el', 'coeff_ah', 'gain_el', 'gain_ah'], inplace=True)
df_data.drop(df_data[df_data.coeff_el < THRESH_COEFF].index, inplace=True)
df_data.drop(df_data[df_data.coeff_ah < THRESH_COEFF].index, inplace=True)

plt.close('all')

fig, ax = plt.subplots(1,1)
for s, speed in enumerate(SPEEDS):
    df_speed = df_data.loc[df_data.freq==speed]
    mu, cf = bland_altman_plot(ax, df_speed.gain_el, df_speed.gain_ah, COL[s], MARK[s])
    # print([mu, cf])
    
plt.title(f'{TASK.upper()} Velocity Gain')
plt.ylabel('Diff (EL - AH)')
plt.xlabel('Mean Velocity Gain')

fig, ax = plt.subplots(1,1)
for s, speed in enumerate(SPEEDS):
    df_speed = df_data.loc[df_data.freq==speed]
    mu, cf = bland_altman_plot(ax, np.abs(df_speed.slope_el), np.abs(df_speed.slope_ah), COL[s], MARK[s])
    print([mu, cf])
    
plt.title(f'{TASK.upper()} Velocity')
plt.ylabel('Diff (EL - AH)')
plt.xlabel('Mean Velocity')

# fig, ax = plt.subplots(3,2, sharex=True, sharey=False)
# for i, eye in enumerate(EYES):
#     df_eye = df_data.loc[df_data.stream==eye]
    
#     for s, speed in enumerate(SPEEDS):
#         df_speed = df_data.loc[df_data.freq==speed]
        
#         mu, cf = bland_altman_plot(ax[s,i], df_speed.slope_el, df_speed.slope_ah)
#         ax[s,i].set_title(f'VSP Velocity: {eye}, Speed: {speed}')
#         ax[s,i].set_ylabel('Diff (EL - AH)')
#         ax[s,i].set_xlabel('Mean Velocity')

#%%
plt.close('all')
fig, ax = plt.subplots(3,2, sharex=True, sharey=False)
for i, eye in enumerate(EYES):
    df_eye = df_data.loc[df_data.stream==eye]
    
    for s, speed in enumerate(SPEEDS):
        df_speed = df_data.loc[df_data.freq==speed]
        
        bland_altman_plot(ax[0,i], df_speed.gain_el, df_speed.gain_ah)
        ax[s,i].set_title(f'VSP Gain: {eye}, Speed: {speed}')
        ax[s,i].set_ylabel('Diff (EL - AH)')
        ax[s,i].set_xlabel('Mean Velocity Gain')
        
fig, ax = plt.subplots(3,2, sharex=True, sharey=False)
for i, eye in enumerate(EYES):
    df_eye = df_data.loc[df_data.stream==eye]
    
    for s, speed in enumerate(SPEEDS):
        df_speed = df_data.loc[df_data.freq==speed]
        
        bland_altman_plot(ax[s,i], df_speed.slope_el, df_speed.slope_ah)
        ax[s,i].set_title(f'VSP Velocity: {eye}, Speed: {speed}')
        ax[s,i].set_ylabel('Diff (EL - AH)')
        ax[s,i].set_xlabel('Mean Velocity')
        
# fig, ax = plt.subplots(3,2, sharex=True, sharey=False)
# for i, eye in enumerate(EYES):
#     df_eye = df_data.loc[df_data.stream==eye]
    
#     for s, speed in enumerate(SPEEDS):
#         df_speed = df_data.loc[df_data.freq==speed]
        
#         bland_altman_plot(ax[s,i], df_speed.slope_tar, df_speed.slope_el)
#         ax[s,i].set_title(f'HSP Velocity: {eye}, Speed: {speed}')
#         ax[s,i].set_ylabel('Diff (STIM - EL)')
#         ax[s,i].set_xlabel('Mean Velocity')
        
# fig, ax = plt.subplots(3,2, sharex=True, sharey=False)
# for i, eye in enumerate(EYES):
#     df_eye = df_data.loc[df_data.stream==eye]
    
#     for s, speed in enumerate(SPEEDS):
#         df_speed = df_data.loc[df_data.freq==speed]
        
#         bland_altman_plot(ax[s,i], df_speed.slope_tar, df_speed.slope_ah)
#         ax[s,i].set_title(f'HSP Velocity: {eye}, Speed: {speed}')
#         ax[s,i].set_ylabel('Diff (STIM - AH)')
#         ax[s,i].set_xlabel('Mean Velocity')
    
#%% BLAND ALTMAN - ALL

#%% BLAND ALTMAN
# fig, ax = plt.subplots(3,5, sharex=True, sharey=True)
task="hsp"
task_type = "linear"
eyes=["right", "left"]
metric="slope"
colors={"right":'r', "left":'b'}

for eye in eyes:
    fig, ax = plt.subplots(3,5, sharex=True, sharey=True)
    ax = ax.flatten()
    
    df_lin = pd.read_csv(f'{task}_fit_{task_type}_per_eye.csv')
    df_lin = df_lin.loc[df_lin.eye==eye,:]
    subjects = list(np.unique(df_lin.subject.values))
    for s, sub in enumerate(subjects):
        df_lin_sub = df_lin.loc[df_lin.subject==sub, :]
        
        bland_altman_plot(ax[s], df_lin_sub[f'el_{metric}_gain'], df_lin_sub[f'ah_{metric}_gain'], colors[eye])
        ax[s].set_title(f'{metric} gain: {sub}')
        ax[s].set_ylabel('Diff (EL - AH)')
        
#%%
task="hsp"
task_type = "sine"
eyes=["right", "left"]
metric="amp"
colors={"right":'r', "left":'b'}

plt.close('all')
for eye in eyes:    
    df_lin = pd.read_csv(f'{task}_fit_{task_type}_per_eye.csv')
    df_lin = df_lin.loc[df_lin.eye==eye,:]
        
    bland_altman_plot(plt.gca(), df_lin[f'el_{metric}_gain'], df_lin[f'ah_{metric}_gain'], colors[eye])
    plt.title(f'{task} : {metric} gain')
    plt.ylabel('Diff (EL - AH)')
    plt.xlabel('Eyelink')
    
#%%
task="hsp"
task_type = "linear"
eyes=["right", "left"]
metric="slope"
colors={"right":'r', "left":'b'}

plt.close('all')
for eye in eyes:    
    df_lin = pd.read_csv(f'{task}_{task_type}_window.csv')
    df_lin = df_lin.loc[df_lin.eye==eye,:]
        
    bland_altman_plot(plt.gca(), df_lin[f'el_{metric}_gain'], df_lin[f'ah_{metric}_gain'], colors[eye])
    plt.title(f'{task} : {metric} gain')
    plt.ylabel('Diff (EL - AH)')
    plt.xlabel('Eyelink')