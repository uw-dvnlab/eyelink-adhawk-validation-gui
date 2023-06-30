# -*- coding: utf-8 -*-
"""
Created on Sun Jun 11 12:28:37 2023

@author: azafar
"""

import numpy as np
import plotly.graph_objects as go
def bland_altman_plot(data1, data2, data1_name='EL', data2_name='AH', 
                      subgroups=None, plotly_template='none', 
                      annotation_offset=0.05, n_sd=1.96, 
                      parameter="parameter", units="unit",
                      range_x=[0,1], range_y=[0,1], marker_sz=10,
                      *args, **kwargs):
    data1 = np.asarray( data1 )
    data2 = np.asarray( data2 )
    mean = np.mean( [data1, data2], axis=0 )
    diff = data1 - data2  # Difference between data1 and data2
    md = np.nanmean( diff )  # Mean of the difference
    sd = np.nanstd( diff, axis=0 )  # Standard deviation of the difference

    font_sz = 30
    marker_op = 0.75
    
    fig = go.Figure()

    if subgroups is None:
        fig.add_trace(
            go.Scatter(
                x=mean,
                y=diff,
                mode='markers',
                marker=dict(
                    color='rgb(255,127,80,.8)',
                    size=marker_sz,
                    opacity=marker_op)
                ))
    else:
        for group_name in np.unique(subgroups):
            group_mask = np.where(np.array(subgroups) == group_name)
            fig.add_trace(
                go.Scatter(
                    x=mean[group_mask],
                    y=diff[group_mask],
                    mode='markers',
                    name=str(group_name),
                    marker=dict(
                        size=marker_sz,
                        opacity=marker_op)
                    ))



    fig.add_shape(
        # Line Horizontal Mean
        type="line",
        xref="paper",
        x0=0,
        y0=md,
        x1=1,
        y1=md,
        line=dict(
            color="Black",
            width=2,
            dash="dashdot",
        ),
        name=f'Mean {round( md, 2 )}',
    )
    fig.add_shape(
        # Line Horizontal - SD
        type="line",
        xref="paper",
        x0=0,
        y0=md - n_sd * sd,
        x1=1,
        y1=md - n_sd * sd,
        line=dict(
            color='rgb(78,121,167,.8)',
            width=2,
            dash="dashdot",
        )
    )
    fig.add_shape(
        # Line Horizontal + SD
        type="line",
        xref="paper",
        x0=0,
        y0=md + n_sd * sd,
        x1=1,
        y1=md + n_sd * sd,
        line=dict(
            color='rgb(78,121,167,.8)',
            width=2,
            dash="dashdot",
        )
    )

    # Remove the title and legend
    fig.update_layout(title=None, showlegend=False)
    
    # Edit the layout
    fig.update_layout( title=f'{parameter} Bland-Altman Plot for {data1_name} and {data2_name}',
                       xaxis_title=f'Mean of Methods ({units})',
                       yaxis_title=f'{data1_name} Minus {data2_name} ({units})',
                       font = dict( size=font_sz ),
                       legend=dict(font = dict(size=16)),
                       template=plotly_template,
                       annotations=[dict(
                                        x=1,
                                        y=md + annotation_offset,
                                        xref="paper",
                                        yref="y",
                                        text="Mean",
                                        font=dict(size=font_sz),
                                        showarrow=False,
                                        arrowhead=0,
                                        ax=50,
                                        ay=0
                                    ),
                                    dict(
                                        x=1,
                                        y=md - annotation_offset,
                                        xref="paper",
                                        yref="y",
                                        text=f"{round(md,2)}",
                                        font=dict(size=font_sz),
                                        showarrow=False,
                                        arrowhead=0,
                                        ax=50,
                                        ay=0
                                    ),
                                   dict(
                                       x=1,
                                       y=n_sd*sd + md + annotation_offset,
                                       xref="paper",
                                       yref="y",
                                       text=f"+{n_sd} SD",
                                       font=dict(size=font_sz,color='rgb(78,121,167,.8)'),
                                       showarrow=False,
                                       arrowhead=0,
                                       ax=0,
                                       ay=-20
                                   ),
                                   dict(
                                       x=1,
                                       y=md - n_sd *sd - annotation_offset,
                                       xref="paper",
                                       yref="y",
                                       text=f"-{n_sd} SD",
                                       font=dict(size=font_sz,color='rgb(78,121,167,.8)'),
                                       showarrow=False,
                                       arrowhead=0,
                                       ax=0,
                                       ay=20
                                   ),
                                   dict(
                                       x=1,
                                       y=md + n_sd * sd - annotation_offset,
                                       xref="paper",
                                       yref="y",
                                       text=f"{round(md + n_sd*sd, 2)}",
                                       font=dict(size=font_sz,color='rgb(78,121,167,.8)'),
                                       showarrow=False,
                                       arrowhead=0,
                                       ax=0,
                                       ay=20
                                   ),
                                   dict(
                                       x=1,
                                       y=md - n_sd * sd + annotation_offset,
                                       xref="paper",
                                       yref="y",
                                       text=f"{round(md - n_sd*sd, 2)}",
                                       font=dict(size=font_sz,color='rgb(78,121,167,.8)'),
                                       showarrow=False,
                                       arrowhead=0,
                                       ax=0,
                                       ay=20
                                   )
                               ])
    # Remove the title and legend
    # fig.update_layout(title=None, showlegend=False)
    
    # Remove the gridlines
    fig.update_xaxes(showgrid=False)
    fig.update_yaxes(showgrid=False)
    
    # Add x-axis line and y-axis line
    fig.update_xaxes(showline=True, linewidth=1, linecolor='black')
    fig.update_yaxes(showline=True, linewidth=1, linecolor='black')
    fig.update_xaxes(range=range_x, automargin=True)
    fig.update_yaxes(range=range_y, automargin=True)
    
       # Add boxed border
    fig.update_layout(
        width=1600,
        height=1000,
        xaxis=dict(
            showline=True,
            linewidth=1,
            linecolor='black',
            mirror=True
        ),
        yaxis=dict(
            showline=True,
            linewidth=1,
            linecolor='black',
            mirror=True
        ),
        plot_bgcolor='white',
        showlegend=False
    )
    
    return fig