function PowerSplitDriveUnitBasic_plot_vehicle(nvpairs)

% Copyright 2020-2021 The MathWorks, Inc.

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

if isfield(nvpairs, 'Dataset')
  logsout = nvpairs.Dataset;
else
  error("Dataset must be specified")
end
if isfield(nvpairs, 'PlotParent')
  parent = nvpairs.PlotParent;
else
  error("PlotParent must be specified")
end

parent.Position(3:4) = [800 1*140];  % figure width and height

tl = tiledlayout(parent, 1, 2);

ax = nexttile(tl);
vals = logsout.get("Vehicle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Vehicle Speed (km/hr)")
hold off

ax = nexttile(tl);
vals = logsout.get("Traveled Distance").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Traveled Distance (km)")
hold off

end  % function
