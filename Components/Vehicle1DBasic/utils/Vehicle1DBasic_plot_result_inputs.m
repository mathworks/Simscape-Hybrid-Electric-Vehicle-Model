function Vehicle1DBasic_plot_result_inputs(nvpairs)
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
parent.Position(3:4) = [600 500];  % width height

tl = tiledlayout(parent, 3, 1);

ax = nexttile(tl);
vals = logsout.get("Axle Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Axle Torque Input (N*m)")
hold off

ax = nexttile(tl);
vals = logsout.get("Road Grade %").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Road Grade (%)")
hold off

ax = nexttile(tl);
vals = logsout.get("Brake Force").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Brake Force (N)")
hold off

end
