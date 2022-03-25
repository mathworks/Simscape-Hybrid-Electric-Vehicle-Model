%% Set up script for Power-Split HEV Model with Direct Input
% The PreLoadFcn callback of the model runs this script.

% Copyright 2020-2022 The MathWorks, Inc.

builder = PowerSplitHEV_DirectInput_InputSignalBuilder;

hevDirectInputData = Constant(builder);

hevDirect_InputSignals = hevDirectInputData.Signals;
hevDirect_InputBus = hevDirectInputData.Bus;

t_end = hevDirectInputData.Options.StopTime_s;

PowerSplitHEV_params
