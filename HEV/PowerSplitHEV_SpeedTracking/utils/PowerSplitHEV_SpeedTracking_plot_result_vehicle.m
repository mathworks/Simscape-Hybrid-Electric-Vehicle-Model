function PowerSplitHEV_SpeedTracking_plot_result_vehicle( nvpair )
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

tl = tiledlayout(parent, 4, 1);

parent.Position(3:4) = [600 500];  % width height

ax = nexttile(tl);
vals = logsout.get("Vehicle Speed Reference").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("Vehicle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlabel(ax, "Time (s)")
title(ax, "Vehicle Speeds (km/hr)")
hold off

ax = nexttile(tl);
vals = logsout.get("Vehicle G Force").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "G Force (-)")
hold off

ax = nexttile(tl);
vals = logsout.get("Brake Force").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Brake Force (N)")
hold off

ax = nexttile(tl);
vals = logsout.get("Road Grade").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Road Grade (%)")
hold off

end
