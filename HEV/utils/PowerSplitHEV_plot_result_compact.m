function PowerSplitHEV_plot_result_compact( nvpairs )
% Plots the simulation result.

% Copyright 2021-2022 The MathWorks, Inc.

%% Process arguments

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpairs.Dataset;
parent = nvpairs.PlotParent;

vals = getValuesFromLogsout(logsout.get("Vehicle Speed km/h"));
x_end = vals.Time(end);

%% Plot

parent.Position(3:4) = [800 700];  % width height

tl = tiledlayout(parent, 3, 3, ...
      'TileSpacing','compact', 'Padding','compact' );

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle Speed km/h"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "Longitudinal Vehicle Speed (km/hr)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("MG2 Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 vals.Time(end)])
xlabel(ax, "Time (s)")
title(ax, "MG2 Speed (rpm)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("MG2 Mechanical Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "MG2 Mechanical Power (kW)")
hold off


ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle G Force"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "Longitudinal G Force")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("MG1 Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "MG1 Speed (rpm)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("MG1 Mechanical Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "MG1 Mechanical Power (kW)")
hold off


ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery SOC"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "HV Battery SOC (%)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Engine Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "Engine Speed (rpm)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Engine Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 x_end])
xlabel(ax, "Time (s)")
title(ax, "Engine Power (kW)")
hold off


end
