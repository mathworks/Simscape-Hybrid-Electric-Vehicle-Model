function Vehicle1D_plot_inputs(inputSignalVariableName, nvpairs)
%% Plots input signals

% Copyright 2022 The MathWorks, Inc.

arguments
  inputSignalVariableName {mustBeTextScalar} = "vehicle_InputSignals"
  nvpairs.Width {mustBePositive, mustBeInteger} = 400
  nvpairs.Height {mustBePositive, mustBeInteger} = 500
end

% This assumes that a variable exists n the base workspace.
inSigs = evalin("base", inputSignalVariableName);

% Get timetable objects.
AxleTrq_tt = inSigs.AxleTrq;
BrkF_tt = inSigs.BrakeForce;
Grade_tt = inSigs.RoadGrade;

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
tlayout.TileIndexing = 'columnmajor';

tl_1 = nexttile;
makePlot(tl_1, AxleTrq_tt, AxleTrq_tt.Time, AxleTrq_tt.AxleTrq, 2)

tl_2 = nexttile;
makePlot(tl_2, BrkF_tt, BrkF_tt.Time, BrkF_tt.BrakeForce, 2)

tl_3 = nexttile;
makePlot(tl_3, Grade_tt, Grade_tt.Time, Grade_tt.RoadGrade, 2)

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
title(varNameStr(timetbl_obj), 'Interpreter','none')
end  % function
