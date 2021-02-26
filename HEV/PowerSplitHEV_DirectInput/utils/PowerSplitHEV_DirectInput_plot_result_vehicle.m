function PowerSplitHEV_DirectInput_plot_result_vehicle( nvpairs )
% plots the simulation result.

% Copyright 2021 The MathWorks, Inc.

%% Process arguments

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpairs.Dataset;
parent = nvpairs.PlotParent;

%% Plot

tl = tiledlayout(parent, 2, 2);

parent.Position(3:4) = [700 400];  % width height

ax = nexttile(tl);
vals = logsout.get("Vehicle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Vehicle Speed (km/hr)")
hold off

ax = nexttile(tl);
vals = logsout.get("Road Grade").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Road Grade (%)")
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

end
