function plotSac(saccades, saccadesP, saccadesM, plt, handles, lim_lines)
    FS = 250;
    if ~isempty(saccades)
        for i=1:size(saccades,1)
            sacOn = saccades(i,1);
            sacLine = plot(plt, ...
                1000*[sacOn, sacOn]/FS, lim_lines, 'r--');
            set(sacLine, 'ButtonDownFcn', {@saccadeLineCallback, handles});
            if any(saccadesP==sacOn*1000/FS)
                set(sacLine, 'LineWidth', 2.5)
            elseif any(saccadesM==sacOn*1000/FS)
                set(sacLine, 'LineWidth', 2.5, 'Color', 'm')
            end
        end
    end
end

function saccadeLineCallback(LineH, EventData, handles)
    lw = get(LineH, 'LineWidth');
    click = get(gcf,'SelectionType');
    if handles.chk_el_sac.Value==1
        def_col = 'r';
        updateLines(LineH,lw,click,def_col);
    elseif handles.chk_ah_sac.Value==1
        def_col = 'b';
        updateLines(LineH,lw,click,def_col);
    end
end

function updateLines(LineH,lw,click,def_col)
    if strcmpi(click, 'normal')
        if lw==2.5
            set(LineH,'LineWidth',0.5,'Color',def_col);
        else
            set(LineH,'LineWidth',2.5,'Color',def_col);
            uistack(LineH,'top');  % Set active line before all others
        end
    else
        if lw==2.5
            set(LineH,'LineWidth',0.5,'Color',def_col);
        else
            set(LineH,'LineWidth',2.5,'Color','m');
            uistack(LineH, 'top');  % Set active line before all others
        end
    end
end