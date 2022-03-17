function plotInputs_harnessPowerSplit_Engine(inputSignalVariableName, nvpairs)
%% Makes a plot of input signals

% Copyright 2022 The MathWorks, Inc.

arguments
  inputSignalVariableName {mustBeTextScalar} = "engineTestInput_Signals"
  nvpairs.Width {mustBePositive, mustBeInteger} = 400
  nvpairs.Height {mustBePositive, mustBeInteger} = 400
end

% This assumes a variable existing in the base workspace.
engInSigs = evalin("base", inputSignalVariableName);

% Get timetable objects.
engTrqCmd_tt = engInSigs.EngTrqCmd;
mg1TrqCmd_tt = engInSigs.MG1TrqCmd;
brkForce_tt = engInSigs.BrkForce;

fig = figure;

% Adjust the figure position in the screen.
pos = fig.Position;
origHeight = pos(4);
figWidth = nvpairs.Width;
figHeight = nvpairs.Height;
fig.Position = [pos(1), pos(2)-(figHeight-origHeight), figWidth, figHeight];

tlayout = tiledlayout(3, 1);
tlayout.TileSpacing = 'compact';
tlayout.Padding = 'compact';

tl_1 = nexttile;
makePlot(tl_1, engTrqCmd_tt, engTrqCmd_tt.Time, engTrqCmd_tt.EngTrqCmd, 2)

tl_2 = nexttile;
makePlot(tl_2, mg1TrqCmd_tt, mg1TrqCmd_tt.Time, mg1TrqCmd_tt.MG1TrqCmd, 2)

tl_3 = nexttile;
makePlot(tl_3, brkForce_tt, brkForce_tt.Time, brkForce_tt.BrkForce, 2)

linkaxes([tl_1 tl_2 tl_3], 'x')

end  % function

function makePlot(parent, timetbl_obj, t, y, threshold_value)

varNameStr = @(tt) string(tt.Properties.VariableNames);
unitStr = @(tt) "(" + string(tt.Properties.VariableUnits) + ")";

plot(parent, t, y, "LineWidth",2)
hold on; grid on
setMinimumYRange( ...
  gca, ...
  y, ...
  dy_threshold = threshold_value );
ylabel(unitStr(timetbl_obj))
title(varNameStr(timetbl_obj))
end  % function
