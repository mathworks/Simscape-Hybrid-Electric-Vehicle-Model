%% Test harness set-up script

% Copyright 2022 The MathWorks, Inc.

PowerSplitHEV_params
HEVPowerSplitControl_params

mg2inputObj = MG2Controller_InputSignalBuilder;

mg2inputData = Input_Constant(mg2inputObj);
inputSignals = mg2inputData.Signals;
inputBus = mg2inputData.Bus;
