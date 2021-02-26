function PowerSplitDriveUnitBasic_plot_psdu(nvpairs)

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

parent.Position(3:4) = [800 600];  % width height

tl = tiledlayout(parent, 4, 2);

ax = nexttile(tl);
vals = logsout.get("Axle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Axle Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("Axle Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Axle Torque (N*m)")
hold off


ax = nexttile(tl);
vals = logsout.get("MG2 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "MG2 Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG2 Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "MG2 Current (A)")
hold off


ax = nexttile(tl);
vals = logsout.get("MG1 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "MG1 Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG1 Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "MG1 Current (A)")
hold off


ax = nexttile(tl);
vals = logsout.get("Engine Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Engine Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("Engine Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Engine Torque (N*m)")
hold off

end  % function
