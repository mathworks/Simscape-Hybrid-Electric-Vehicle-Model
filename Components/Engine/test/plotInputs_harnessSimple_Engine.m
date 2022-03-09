function plotInputs_harnessSimple_Engine(inputSignalVariableName)
%% Makes a plot of input signals

% Copyright 2022 The MathWorks, Inc.

arguments
  inputSignalVariableName {mustBeTextScalar} = "engineTestInput_Signals"
end

% This assumes a variable existing in the base workspace.
engineInput_Signals = evalin("base", inputSignalVariableName);

% Get a timetable object.
engTrqCmd_tt = engineInput_Signals.EngTrqCmd;

t = engTrqCmd_tt.Time;
y = engTrqCmd_tt.EngTrqCmd;

signalName = string(engTrqCmd_tt.Properties.VariableNames{1});
unitStr = "(" + string(engTrqCmd_tt.Properties.VariableUnits{1}) + ")";

figure
hold on; grid on
p = plot(t, y, "LineWidth",2);
setMinimumYRange( ...
  gca, ...
  y, ...
  dy_threshold = 2 );
ylabel(unitStr)
title(signalName)

end  % function
