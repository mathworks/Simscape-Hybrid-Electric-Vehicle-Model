function PowerSplitDriveUnit_plot_inputs(inputSignalVariableName, nvpairs)
%% Makes a plot of input signals

% Copyright 2022 The MathWorks, Inc.

arguments
  inputSignalVariableName {mustBeTextScalar} = "PSDU_InputSignals"
  nvpairs.Width {mustBePositive, mustBeInteger} = 400
  nvpairs.Height {mustBePositive, mustBeInteger} = 600
end

% This assumes a variable existing in the base workspace.
inSigs = evalin("base", inputSignalVariableName);

% Get timetable objects.
EngTrqCmd_tt = inSigs.EngTrqCmd;
Mg1TrqCmd_tt = inSigs.Mg1TrqCmd;
Mg2TrqCmd_tt = inSigs.Mg2TrqCmd;
HVBattV_tt = inSigs.HVBattV;
AxleSpd_OnOff_tt = inSigs.AxleSpd_OnOff;
AxleSpd_tt = inSigs.AxleSpd;
AxleTrq_tt = inSigs.AxleTrq;
BrkForce_tt = inSigs.BrkForce;

fig = figure;

% Adjust the figure position in the screen.
pos = fig.Position;
origHeight = pos(4);
figWidth = nvpairs.Width;
figHeight = nvpairs.Height;
fig.Position = [pos(1), pos(2)-(figHeight-origHeight), figWidth, figHeight];

tlayout = tiledlayout(4, 2);
tlayout.TileSpacing = 'compact';
tlayout.Padding = 'compact';
tlayout.TileIndexing = 'columnmajor';

tl_1 = nexttile;
makePlot(tl_1, EngTrqCmd_tt, EngTrqCmd_tt.Time, EngTrqCmd_tt.EngTrqCmd, 2)

tl_2 = nexttile;
makePlot(tl_2, Mg1TrqCmd_tt, Mg1TrqCmd_tt.Time, Mg1TrqCmd_tt.Mg1TrqCmd, 2)

tl_3 = nexttile;
makePlot(tl_3, Mg2TrqCmd_tt, Mg2TrqCmd_tt.Time, Mg2TrqCmd_tt.Mg2TrqCmd, 2)

tl_4 = nexttile;
makePlot(tl_4, HVBattV_tt, HVBattV_tt.Time, HVBattV_tt.HVBattV, 2)

tl_5 = nexttile;
makePlot(tl_5, AxleSpd_OnOff_tt, AxleSpd_OnOff_tt.Time, AxleSpd_OnOff_tt.AxleSpd_OnOff, 1)

tl_6 = nexttile;
makePlot(tl_6, AxleSpd_tt, AxleSpd_tt.Time, AxleSpd_tt.AxleSpd, 2)

tl_7 = nexttile;
makePlot(tl_7, AxleTrq_tt, AxleTrq_tt.Time, AxleTrq_tt.AxleTrq, 2)

tl_8 = nexttile;
makePlot(tl_8, BrkForce_tt, BrkForce_tt.Time, BrkForce_tt.BrkForce, 2)

linkaxes([tl_1 tl_2 tl_3 tl_4 tl_5 tl_6 tl_7 tl_8], 'x')

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
