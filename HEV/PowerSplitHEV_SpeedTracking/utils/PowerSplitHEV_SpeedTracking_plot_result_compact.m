function PowerSplitHEV_SpeedTracking_plot_result_compact( nvpair )
% plots the simulation result.

% Copyright 2021 The MathWorks, Inc.

%% Process arguments

arguments
  nvpair.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpair.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpair.Dataset;
parent = nvpair.PlotParent;

%% Plot

parent.Position(3:4) = [800 700];  % width height

tl = tiledlayout(parent, 3, 2, ...
      'TileSpacing','compact', 'Padding','compact' );

ax = nexttile(tl);
vals = logsout.get("Vehicle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',1)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Longitudinal Vehicle Speed (km/hr)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG2 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',1)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG2 Speed (rpm)")
hold off


ax = nexttile(tl);
vals = logsout.get("Vehicle G Force").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',1)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Longitudinal G Force")
hold off

ax = nexttile(tl);
vals = logsout.get("MG1 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',1)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG1 Speed (rpm)")
hold off


ax = nexttile(tl);
vals = logsout.get("HV Battery SOC").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',1)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "HV Battery SOC (%)")
hold off

ax = nexttile(tl);
vals = logsout.get("Engine Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',1)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Engine Speed (rpm)")
hold off


end
