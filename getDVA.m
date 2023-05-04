function [deg_EL, deg_AH] = getDVA(task, raw_EL, raw_AH, dim)
RES = [1024, 768]; % px
DIM = [35.2, 26.4]; % cm
DIST = 80; % cm
POLARITY = 1;
lbl_ah_z = ["Gaze_Z_Left", "Gaze_Z_Right"];

if dim==1
    lbl_el = ["LX", "RX"];
    lbl_ah = ["Gaze_X_Left", "Gaze_X_Right"];
    d_dim = DIM(1);
    d_res = RES(1);
else
    lbl_el = ["LY", "RY"];
    lbl_ah = ["Gaze_Y_Left", "Gaze_Y_Right"];
    d_dim = DIM(2);
    d_res = RES(2);
    POLARITY = -1;
end

% Eyelink
EL_L = atan2d(d_dim(1) * ((raw_EL.(char(lbl_el(1))) / d_res(1)) - 0.5), DIST);
EL_R = atan2d(d_dim(1) * ((raw_EL.(char(lbl_el(2))) / d_res(1)) - 0.5), DIST);

% Adhawk
AH_L = asind(raw_AH.(char(lbl_ah(1))));
AH_R = asind(raw_AH.(char(lbl_ah(2))));
% AH_Lt = atand(raw_AH.(char(lbl_ah(1))) ./ (-1*raw_AH.(char(lbl_ah_z(1)))));
% AH_Rt = atand(raw_AH.(char(lbl_ah(2))) ./ (-1*raw_AH.(char(lbl_ah_z(2)))));
AH_Lt = atan2d(raw_AH.(char(lbl_ah(1))), (-1*raw_AH.(char(lbl_ah_z(1)))));
AH_Rt = atan2d(raw_AH.(char(lbl_ah(2))), (-1*raw_AH.(char(lbl_ah_z(2)))));

if dim==1
    assignin('base','AHL',[AH_L, AH_Lt]);
    assignin('base','AHR',[AH_R, AH_Rt]);
    
    max([max(abs(diff([AH_R, AH_Rt], 1, 2))), max(abs(diff([AH_L, AH_Lt], 1, 2)))])
end
% Adjust
if strcmp(task, 'HSP') || strcmp(task, 'VSP')
    mu_el_l = nanmean(EL_L(1:round(length(EL_L)/2)));
    mu_el_r = nanmean(EL_R(1:round(length(EL_R)/2)));
    EL_POL_L = 1;
    EL_POL_R = 1;
    if mu_el_l<0
        EL_POL_L = 1;
    end
    if mu_el_r<0
        EL_POL_R = 1;
    end
    EL_R = EL_R * EL_POL_R;
    EL_L = EL_L * EL_POL_L;
end
if strcmp(task, 'HSP') || strcmp(task, 'VSP')
    mu_ah_l = nanmean(AH_L(1:round(length(AH_L)/2)));
    mu_ah_r = nanmean(AH_R(1:round(length(AH_R)/2)));
    AH_POL_L = 1;
    AH_POL_R = 1;
    if mu_ah_l<0
        AH_POL_L = 1;
    end
    if mu_ah_r<0
        AH_POL_R = 1;
    end
    AH_R = AH_R * AH_POL_R;
    AH_L = AH_L * AH_POL_L;
end

deg_EL = POLARITY * [EL_R, EL_L, (EL_L + EL_R) / 2];
deg_AH = [AH_R, AH_L, (AH_L + AH_R) / 2];