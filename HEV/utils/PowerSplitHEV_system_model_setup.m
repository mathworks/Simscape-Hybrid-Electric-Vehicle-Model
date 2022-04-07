%% Set up script for Power-Split HEV Model
% The PostLoadFcn callback of the model runs this script.
% This script needs to run after the model is loaded so that gcs works.

% Copyright 2022 The MathWorks, Inc.

tmp_DrvCtl_RefSub = get_param(gcs+"/Controller & Environment", "ReferencedSubsystem");

switch tmp_DrvCtl_RefSub

case 'PowerSplitHEV_SpeedTracking_refsub'
  PowerSplitHEV_SpeedTracking_selectInput("InputPattern", "SimpleDrivePattern");

case 'PowerSplitHEV_DirectInput_refsub'
  PowerSplitHEV_DirectInput_selectInput("InputPattern", "PowerSplitDrive");

otherwise
  disp("Unknown referenced subsystem for the Controller & Environment block.")

end  % switch

clear tmp_DrvCtl_RefSub
