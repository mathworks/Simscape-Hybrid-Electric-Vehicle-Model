function PowerSplitHEV_plot_result_vehicle( nvpair )
% Plots the simulation result.

% Copyright 2021-2022 The MathWorks, Inc.

%% Process arguments

arguments
  nvpair.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpair.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpair.Dataset;
parent = nvpair.PlotParent;

%% Plot

parent.Position(3:4) = [700 500];  % width height

tl = tiledlayout(parent, 3, 2, ...
      'TileSpacing','compact', 'Padding','compact' );

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = getValuesFromLogsout(logsout.get("Vehicle Speed Reference (km/hr)"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlim([0 vals.Time(end)])
xlabel(ax, "Time (s)")
title(ax, "Vehicle Speed & Reference (km/hr)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle Incline"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = getValuesFromLogsout(logsout.get("Road Grade"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlim([0 vals.Time(end)])
xlabel(ax, "Time (s)")
title(ax, "Vehicle Incline (deg) & Road Grade (%)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Vehicle G Force"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 vals.Time(end)])
xlabel(ax, "Time (s)")
title(ax, "G Force (-)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Brake On Off"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 vals.Time(end)])
xlabel(ax, "Time (s)")
title(ax, "Brake On Off")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Axle Speed"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("Axle Speed Reference").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlim([0 vals.Time(end)])
xlabel(ax, "Time (s)")
title(ax, "Axle Speed & Reference (rpm)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Brake Force"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlim([0 vals.Time(end)])
xlabel(ax, "Time (s)")
title(ax, "Brake Force (N)")
hold off

end
