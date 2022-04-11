function PowerSplitHEV_DirectInput_selectInput(nvpairs)
%% Select Input Pattern for Power-Split HEV with Direct Torque Input

% Copyright 2022 The MathWorks, Inc.

arguments
  nvpairs.InputPattern {mustBeTextScalar, mustBeMember(nvpairs.InputPattern, ...
    [ "Constant" ...
      "Downhill" ...
      "EngineDrive" ...
      "MG1Drive" ...
      "MG2Drive" ...
      "MG2Drive_StartEngine" ...
      "Parked_EngineChargeBattery" ...
      "PowerSplitDrive"])} ...
    = "PowerSplitDrive"
  nvpairs.DisplayMessage (1,1) logical = false
  nvpairs.DisplayPlot (1,1) logical = false
end

inputPattern = nvpairs.InputPattern;
dispMsg = nvpairs.DisplayMessage;
dispPlot = nvpairs.DisplayPlot;

%%
if dispMsg
  disp("Selecting input: " + inputPattern)
end

builder = PowerSplitHEV_DirectInput_InputSignalBuilder;
builder.Plot_tf = dispPlot;

inpData = feval(char(inputPattern), builder);

assignin('base', 'hevDirect_InputSignals', inpData.Signals)
assignin('base', 'hevDirect_InputBus', inpData.Bus)

assignin('base', 't_end', inpData.Options.StopTime_s)

end  % function
