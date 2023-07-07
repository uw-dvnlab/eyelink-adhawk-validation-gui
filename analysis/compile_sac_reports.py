# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 13:17:27 2023

@author: azafar
"""
import numpy as np
import pandas as pd

task = 'hms'
nsubs = 13
for n in range(nsubs):
    num = "%02d" % (n+1)
    df_sub = pd.read_csv(f'./saccades/{task}/AE{num}_{task.upper()}_export.csv')
    if n==0:
        df_data = df_sub.copy()
    else:
        df_data = pd.concat([df_data, df_sub.copy()])

# df_data.drop(df_data[df_data.EL_quality != 1].index, inplace=True)
# df_data.drop(df_data[df_data.AH_quality != 1].index, inplace=True)
df_data = df_data[["subject",
                   "EL_Right_P1_amp", "EL_Right_P1_vel",
                   "EL_Left_P1_amp", "EL_Left_P1_vel",
                   "AH_Right_P1_amp", "AH_Right_P1_vel",
                   "AH_Left_P1_amp", "AH_Left_P1_vel"]]
df_data.dropna(inplace=True)

el_amp_r_p1 = df_data.loc[:, ["subject", "EL_Right_P1_amp", "EL_Right_P1_vel"]]
# el_amp_r_p2 = df_data.loc[:, ["subject", "EL_Right_P2_amp", "EL_Right_P2_vel"]]
ah_amp_r_p1 = df_data.loc[:, ["subject", "AH_Right_P1_amp", "AH_Right_P1_vel"]]
# ah_amp_r_p2 = df_data.loc[:, ["subject", "AH_Right_P2_amp", "AH_Right_P2_vel"]]
el_amp_l_p1 = df_data.loc[:, ["subject", "EL_Left_P1_amp", "EL_Left_P1_vel"]]
# el_amp_l_p2 = df_data.loc[:, ["subject", "EL_Left_P2_amp", "EL_Left_P2_vel"]]
ah_amp_l_p1 = df_data.loc[:, ["subject", "AH_Left_P1_amp", "AH_Left_P1_vel"]]
# ah_amp_l_p2 = df_data.loc[:, ["subject", "AH_Left_P2_amp", "AH_Left_P2_vel"]]

el_amp_r_p1.columns = ['subject', 'amp', 'vel']
# el_amp_r_p2.columns = ['subject', 'amp', 'vel']
ah_amp_r_p1.columns = ['subject', 'amp', 'vel']
# ah_amp_r_p2.columns = ['subject', 'amp', 'vel']
el_amp_l_p1.columns = ['subject', 'amp', 'vel']
# el_amp_l_p2.columns = ['subject', 'amp', 'vel']
ah_amp_l_p1.columns = ['subject', 'amp', 'vel']
# ah_amp_l_p2.columns = ['subject', 'amp', 'vel']

# el_amp_r = pd.concat([el_amp_r_p1, el_amp_r_p2])
# el_amp_l = pd.concat([el_amp_l_p1, el_amp_l_p2])
# ah_amp_r = pd.concat([ah_amp_r_p1, ah_amp_r_p2])
# ah_amp_l = pd.concat([ah_amp_l_p1, ah_amp_l_p2])
el_amp_r = el_amp_r_p1.copy()
el_amp_l = el_amp_l_p1.copy()
ah_amp_r = ah_amp_r_p1.copy()
ah_amp_l = ah_amp_l_p1.copy()

el_amp_r['eye'] = 'right'
el_amp_l['eye'] = 'left'
ah_amp_r['eye'] = 'right'
ah_amp_l['eye'] = 'left'

df_el = pd.concat([el_amp_r, el_amp_l])
df_ah = pd.concat([ah_amp_r, ah_amp_l])

df_el['tracker'] = 'EL'
df_ah['tracker'] = 'ML'

# df_el.dropna(inplace=True)
# df_ah.dropna(inplace=True)

print(f'EL: {len(df_el)/2}')
print(f'AH: {len(df_ah)/2}')

df_out = pd.concat([df_el, df_ah])
df_out.to_csv(f'./saccades/{task}/{task}_data.csv')

#%%
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 13:17:27 2023

@author: azafar
"""
import pandas as pd

task = 'hms'
nsubs = 13
for n in range(nsubs):
    num = "%02d" % (n+1)
    df_sub = pd.read_csv(f'./saccades/{task}/AE{num}_{task.upper()}_export.csv')
    if n==0:
        df_data = df_sub.copy()
    else:
        df_data = pd.concat([df_data, df_sub.copy()])

# df_data.drop(df_data[df_data.EL_quality != 1].index, inplace=True)
# df_data.drop(df_data[df_data.AH_quality != 1].index, inplace=True)
df_data = df_data[["subject",
                   "EL_Right_P1_amp", "EL_Right_P1_vel",
                   "EL_Left_P1_amp", "EL_Left_P1_vel",
                   "AH_Right_P1_amp", "AH_Right_P1_vel",
                   "AH_Left_P1_amp", "AH_Left_P1_vel"]]
df_data.dropna(inplace=True)

df_el = df_data.loc[:, ["subject", "EL_Right_P1_amp", "EL_Left_P1_amp"]]
df_ah = df_data.loc[:, ["subject", "AH_Right_P1_amp", "AH_Left_P1_amp"]]

df_el.columns = ['subject', 'amp_r', 'amp_l']
df_ah.columns = ['subject', 'amp_r', 'amp_l']

df_el['diff'] = df_el.amp_r - df_el.amp_l
df_ah['diff'] = df_ah.amp_r - df_ah.amp_l

df_ideal = df_el.copy()
df_ideal['diff'] = 0

df_el['tracker'] = 'EL'
df_ah['tracker'] = 'ML'
df_ideal['tracker'] = 'Ideal'

df_out = pd.concat([df_el, df_ah, df_ideal])
df_out = df_out.groupby(['subject', 'tracker']).mean().reset_index()
df_out.to_csv(f'./saccades/{task}/{task}_anova_data.csv')