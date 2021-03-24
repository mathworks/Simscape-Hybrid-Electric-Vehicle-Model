%% Setup for Driving Pattern Component

% Copyright 2021 The MathWorks, Inc.

[inputSignals_DrivingPattern, inputBus_DrivingPattern, initial, opt] = ...
  DrivingPatternBasic_inputs( ...
    "InputPattern","simple_drive_pattern", ...
    "TimeStep",0.1 );

drivingPattern.useFromWorkspace_tf = opt.useFromWorkspace;

t_end = opt.t_end;
