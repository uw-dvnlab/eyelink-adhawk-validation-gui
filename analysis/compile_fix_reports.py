# -*- coding: utf-8 -*-
"""
Created on Sun Jul  2 00:17:48 2023

@author: azafar
"""

# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 18:38:35 2023

@author: azafar
"""
import pandas as pd
import numpy as np

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

df_el_r = df_data.loc[:, ['subject', 'el_rx_sd', 'el_ry_sd', 'el_r_bcea']]
df_el_l = df_data.loc[:, ['subject', 'el_lx_sd', 'el_ly_sd', 'el_l_bcea']]
df_ah_r = df_data.loc[:, ['subject', 'ah_rx_sd', 'ah_ry_sd', 'ah_r_bcea']]
df_ah_l = df_data.loc[:, ['subject', 'ah_lx_sd', 'ah_ly_sd', 'ah_l_bcea']]

df_el_r.columns = ['subject', 'sd_x', 'sd_y', 'bcea']
df_el_l.columns = ['subject', 'sd_x', 'sd_y', 'bcea']
df_ah_r.columns = ['subject', 'sd_x', 'sd_y', 'bcea']
df_ah_l.columns = ['subject', 'sd_x', 'sd_y', 'bcea']

df_el = pd.concat([df_el_r, df_el_l])
df_ah = pd.concat([df_ah_r, df_ah_l])
df_el['tracker'] = 'EL'
df_ah['tracker'] = 'ML'

df_out = pd.concat([df_el, df_ah])
df_out = df_out.groupby(['subject', 'tracker']).mean().reset_index()
df_out.to_csv('./fixation_stability/fixation_stability_stats.csv')