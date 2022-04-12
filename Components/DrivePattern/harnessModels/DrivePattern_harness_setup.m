%% Setup for Driving Pattern Component

% Copyright 2021 The MathWorks, Inc.

drvPtnSigBuilder = DrivePattern_InputSignalBuilder;

inpData = Accelerate_Decelerate(drvPtnSigBuilder);

drivePatternFromWorkspace = inpData.Options.useFromWorkspace;

drivePattern_Signals = inpData.Signals;
drivePattern_Bus = inpData.Bus;

t_end = inpData.Options.StopTime_s;
