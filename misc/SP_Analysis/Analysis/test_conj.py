# -*- coding: utf-8 -*-
"""
Created on Sat May 27 23:40:17 2023

@author: azafar
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

TASK="hsp"

df_data = pd.read_csv(f'./export/conj_{TASK}.csv')
df_data.dropna(subset=['conj'], inplace=True)

df_conj = df_data.groupby(['subject', 'stream', 'freq'])['conj'].mean().reset_index()

sns.stripplot(data=df_conj, x='stream', y='conj', hue='stream',
               size=5, alpha=0.7, linewidth=0, palette="deep", dodge=False)
sns.pointplot(data=df_conj, x='stream', y='conj', hue='stream', join=False,
              errorbar='se', capsize=.2, errwidth=2)
plt.ylim(-2,2)
plt.xlabel('source')
plt.title(f'{TASK.upper()} Conjugacy')
plt.legend([],[],frameon=False)

#%%
from scipy import stats

df_conj_stream = df_conj.groupby(['subject', 'stream'])['conj'].mean().reset_index()
df_conj_stream = df_conj_stream.pivot(index='subject', columns='stream', values='conj')

df_conj_stream_el = df_conj_stream[['eyelink', 'target']]
df_conj_stream_ah = df_conj_stream[['adhawk', 'target']]

df_conj_stream_el.dropna(inplace=True)
df_conj_stream_ah.dropna(inplace=True)

print(stats.ttest_rel(
    df_conj_stream_el.target.values,
    df_conj_stream_el.eyelink.values
    ))

print(stats.ttest_rel(
    df_conj_stream_ah.target.values,
    df_conj_stream_ah.adhawk.values
    ))

#%%
def mean_confidence_interval(data, confidence=0.95):
    a = 1.0 * np.array(data)
    n = len(a)
    m, se = np.mean(a), stats.sem(a)
    h = se * stats.t.ppf((1 + confidence) / 2., n-1)
    return m, m-h, m+h

print(mean_confidence_interval(df_conj_stream_el.eyelink.values))
print(mean_confidence_interval(df_conj_stream_ah.adhawk.values))