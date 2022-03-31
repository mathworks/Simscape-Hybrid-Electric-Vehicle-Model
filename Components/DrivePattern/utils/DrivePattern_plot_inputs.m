function DrivePattern_plot_inputs(inputSignalVariableName, nvpairs)
%% Plots input signals

% Copyright 2022 The MathWorks, Inc.

%{
DrivePattern_plot_inputs("inputSignals_DrivingPattern")
%}

arguments
  inputSignalVariableName {mustBeTextScalar} = "drivePattern_InputSignals"
  nvpairs.Width {mustBePositive, mustBeInteger} = 600
  nvpairs.Height {mustBePositive, mustBeInteger} = 500
end

% This assumes that a variable exists n the base workspace.
inSigs = evalin("base", inputSignalVariableName);

% Get timetable objects.
VehSpdRef_tt = inSigs.VehSpdRef;
VehAccRef_tt = inSigs.VehAccRef;

fig = figure;

% Adjust the figure position in the screen.
pos = fig.Position;
origHeight = pos(4);
figWidth = nvpairs.Width;
figHeight = nvpairs.Height;
fig.Position = [pos(1), pos(2)-(figHeight-origHeight), figWidth, figHeight];

tlayout = tiledlayout(2, 1);
tlayout.TileSpacing = 'compact';
tlayout.Padding = 'compact';
% tlayout.TileIndexing = 'columnmajor';

tl_1 = nexttile;
makePlot(tl_1, VehSpdRef_tt, VehSpdRef_tt.Time, VehSpdRef_tt.VehSpdRef, 2)

tl_2 = nexttile;
makePlot(tl_2, VehAccRef_tt, VehAccRef_tt.Time, VehAccRef_tt.VehAccRef, 2)

linkaxes([tl_1 tl_2], 'x')

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
title(varNameStr(timetbl_obj), 'Interpreter','none')
end  % function
