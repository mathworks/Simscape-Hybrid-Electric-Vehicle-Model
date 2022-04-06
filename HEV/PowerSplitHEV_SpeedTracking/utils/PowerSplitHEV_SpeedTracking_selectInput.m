function PowerSplitHEV_SpeedTracking_selectInput(nvpairs)
%% Select Input Pattern for Power-Split HEV with Speed Tracking

% Copyright 2021-2022 The MathWorks, Inc.

arguments
  nvpairs.InputPattern {mustBeTextScalar} = "Accelerate_Decelerate"
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

% Longitudinal vehicle speed reference
drvPtnSigBuilder = DrivePattern_InputSignalBuilder;
drvPtnSigBuilder.Plot_tf = dispPlot;

inpData = feval(char(inputPattern), drvPtnSigBuilder);

assignin('base', 'drivePatternFromWorkspace', inpData.Options.useFromWorkspace)

assignin('base', 'drivePattern_Signals', inpData.Signals)
assignin('base', 'drivePattern_Bus', inpData.Bus)

% Road grade
if dispPlot
  fig = figure;
  [inputSignals, inputBus, opt2] = ...
    DriverAndEnvironment_road_grade_pattern( ...
      "InputPattern", "flat", ...
      "PlotParent", fig );
else
  [inputSignals, inputBus, opt2] = ...
    DriverAndEnvironment_road_grade_pattern( ...
      "InputPattern", "flat");
end
assignin('base', 'inputSignals_RoadGrade', inputSignals)
assignin('base', 'inputBus_RoadGrade', inputBus)

% Simulation time
t_end = max(inpData.Options.StopTime_s, opt2.t_end);
assignin('base', 't_end', t_end)

end  % function
