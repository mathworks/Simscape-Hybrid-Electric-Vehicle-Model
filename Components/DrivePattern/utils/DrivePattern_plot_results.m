function DrivePattern_plot_results(logsout, nvpairs)
% Creates plots of simulation results

% Copyright 2022 The MathWorks, Inc.

arguments
  logsout (1,1) Simulink.SimulationData.Dataset
  nvpairs.SpeedUnit {mustBeMember(nvpairs.SpeedUnit, {'m/s', 'km/hr', 'mph'})} = "km/hr"
  nvpairs.PlotExtraSignals (1,1) logical = false
  nvpairs.FigureWidth (1,1) {mustBePositive} = 800
  nvpairs.FigureHeight (1,1) {mustBePositive} = 200
end

spdUnit = nvpairs.SpeedUnit;

plotExtra = nvpairs.PlotExtraSignals;

figWidth = nvpairs.FigureWidth;
figHeight = nvpairs.FigureHeight;

%%

fig = figure;
fig.Position(3:4) = [figWidth figHeight];

vals = getValuesFromLogsout(logsout.get("Vehicle Speed Reference (" + spdUnit + ")"));
plot(vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(gca, vals.Data, "dy_threshold",2);
xlabel("Time (s)")
title("Vehicle Speed Reference (" + spdUnit + ")")

if plotExtra

  fig = figure;
  fig.Position(3:4) = [figWidth 300];

  tl = tiledlayout(fig, 3, 1);
  tl.TileSpacing = 'compact';
  tl.TileIndexing = 'columnmajor';

  ax = nexttile(tl);
  vals = getValuesFromLogsout(logsout.get("Vehicle Stop Trigger"));
  plot(ax, vals.Time, vals.Data, 'LineWidth',2)
  hold on;  grid on
  setMinimumYRange(ax, vals.Data, "dy_threshold",1);
  xlabel(ax, "Time (s)")
  title(ax, "Vehicle Stop Trigger (0/1)")
  hold off

  ax = nexttile(tl);
  vals = getValuesFromLogsout(logsout.get("Vehicle Start Trigger"));
  plot(ax, vals.Time, vals.Data, 'LineWidth',2)
  hold on;  grid on
  setMinimumYRange(ax, vals.Data, "dy_threshold",1);
  xlabel(ax, "Time (s)")
  title(ax, "Vehicle Start Trigger (0/1)")
  hold off

  ax = nexttile(tl);
  vals = getValuesFromLogsout(logsout.get("Brake On/Off"));
  plot(ax, vals.Time, vals.Data, 'LineWidth',2)
  hold on;  grid on
  setMinimumYRange(ax, vals.Data, "dy_threshold",1);
  xlabel(ax, "Time (s)")
  title(ax, "Brake On (0/1)")
  hold off

end  % idf

end  % function
