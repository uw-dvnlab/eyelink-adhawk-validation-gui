# -*- coding: utf-8 -*-
"""
Created on Sat May 27 23:40:17 2023

@author: azafar
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

TASK="vsp"

df_data = pd.read_csv(f'./export/gains_{TASK}_long.csv')
df_data.dropna(subset=['coeff', 'slope', 'gain'], inplace=True)

df_gain = df_data.groupby(['subject', 'source', 'freq'])['gain'].mean().reset_index()
#%%
LABELS = ['eyelink', 'adhawk']
sns.stripplot(data=df_gain, x='source', y='gain', hue='source',
               size=5, alpha=0.7, linewidth=0, palette="deep", dodge=False,
               order=LABELS)
sns.pointplot(data=df_gain, x='source', y='gain', hue='source', join=False,
              errorbar='se', capsize=.2, errwidth=2,
              order=LABELS)
plt.ylim(0.25,1.15)
plt.title(f'{TASK.upper()} Velocity Gain')
plt.legend([],[],frameon=False)

#%%
from scipy import stats

df_gain_src = df_gain.groupby(['subject', 'source'])['gain'].mean().reset_index()
df_gain_src = df_gain_src.pivot(index='subject', columns='source', values='gain')

df_gain_src.dropna(inplace=True)

print(stats.ttest_rel(
    df_gain_src.eyelink.values,
    df_gain_src.adhawk.values
    ))


#%%
def mean_confidence_interval(data, confidence=0.95):
    a = 1.0 * np.array(data)
    n = len(a)
    m, se = np.mean(a), stats.sem(a)
    h = se * stats.t.ppf((1 + confidence) / 2., n-1)
    return m, m-h, m+h

print(mean_confidence_interval(df_gain_src.eyelink.values))
print(mean_confidence_interval(df_gain_src.adhawk.values))