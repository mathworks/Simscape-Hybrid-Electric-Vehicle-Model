%% Setup for Testing Power-Split HEV Model with Direct Input
% The PreLoadFcn callback of the model runs this script.

% Copyright 2020-2021 The MathWorks, Inc.

[inputSignals_DirectIn, inputBus_DirectIn, t_end] = ...
  PowerSplitHEV_DirectInput_inputs("InputPattern", "power_split_drive");

PowerSplitHEV_params
