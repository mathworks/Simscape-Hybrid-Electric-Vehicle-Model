function Engine_plot_results(logsout)

% Copyright 2022 The MathWorks, Inc.

arguments
  logsout (1,1) Simulink.SimulationData.Dataset
end

fig = figure;
fig.Position(3:4) = [600 600];  % width height

tl = tiledlayout(fig, 4, 3);
tl.TileSpacing = 'tight';
tl.Padding = 'tight';
tl.TileIndexing = 'columnmajor';

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Engine Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Engine Speed (rpm)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Engine Torque"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Engine Torque (N*m)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Engine Torque Command"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Enigne Torque Command (N*m)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Engine Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Engine Power (kW)")
hold off



ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("MG1 Torque Command"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "MG1 Torque Command (N*m)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Axle Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Axle Power (kW)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Axle Torque"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Axle Torque (N*m)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Axle Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Axle Speed (rpm)")
hold off



ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Brake Force"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Brake Force (N)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Vehicle Speed (km/hr)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Vehicle Power (kW)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Travelled Distance"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Travelled Distance (km)")
hold off

end  % function
