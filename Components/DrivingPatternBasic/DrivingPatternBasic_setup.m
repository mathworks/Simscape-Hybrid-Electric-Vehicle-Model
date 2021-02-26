%% Setup for Driving Pattern Component

% Copyright 2021 The MathWorks, Inc.

[inputSignals_DrivingPattern, inputBus_DrivingPattern, t_end] = ...
  DrivingPatternBasic_inputs("InputPattern", "accelerate_decelerate");

drivingPattern.useFromWorkspace_tf = true;
