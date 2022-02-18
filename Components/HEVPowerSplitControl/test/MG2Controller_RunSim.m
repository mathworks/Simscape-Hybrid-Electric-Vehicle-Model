%% Simulation driver script

% This requires Simulink Test.

% Copyright 2022 The MathWorks, Inc.

modelName = "MG2Controller_TestHarness";
observerName = "MG2Controller_Observer1";

%% Open models

if not(bdIsLoaded(modelName))
  load_model(modelName)
end

if not(bdIsLoaded(observerName))
  load_model(observerName)
end

%% Set up parameters

PowerSplitHEV_params
HEVPowerSplitControl_params

mg2inputObj = MG2Controller_InputSignalBuilder;

% mg2inputObj.Plot_tf = true;

mg2inputData = SweepChargeLevel(mg2inputObj);

inputSignals = mg2inputData.Signals;
inputBus = mg2inputData.Bus;

%% Run simulation

set_param(observerName, "StopTime", num2str(mg2inputData.Options.StopTime_s));

simIn = Simulink.SimulationInput(modelName);
simIn = setModelParameter(simIn, "StopTime", num2str(mg2inputData.Options.StopTime_s));

simOut = sim(simIn);
