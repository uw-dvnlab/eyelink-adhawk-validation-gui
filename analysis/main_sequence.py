# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 20:21:49 2023

@author: azafar
"""

import matplotlib.pyplot as plt

def plot_main_sequence(num, dict_data):
    my_dpi = 96
    plt.close('all')
    plt.figure(figsize=(1000/my_dpi, 1000/my_dpi), dpi=my_dpi)
    plt.rcParams.update({'font.size': 22})
    
    for i in range(len(dict_data['raw'])):
        main_sequence(num,
                      dict_data['raw'][i],
                      dict_data['fit'][i],
                      dict_data['asymp'][i],
                      dict_data['color'][i],
                      dict_data['label'][i])
        
    plt.show()

def main_sequence(num, raw, fit, asymp, color, label):
    # raw data
    plt.plot(raw[0], raw[1], color=color, marker='o', linestyle='None', alpha=0.2)
    # fit
    plt.plot(fit[0], fit[1], color=color, lw=6, label=label)
    # asymptote
    plt.plot([fit[0][0],fit[0][-1]], [asymp, asymp], color=color, lw=6, linestyle='--')
    # params
    plt.ylim(0, 800)
    plt.legend()
    plt.title(f'Horizontal Main Sequence: AE{num}')
    plt.xlabel('Amplitude (dva)')
    plt.ylabel('Velocity (dva/s)')