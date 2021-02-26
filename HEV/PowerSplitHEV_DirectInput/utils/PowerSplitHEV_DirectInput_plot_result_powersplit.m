function PowerSplitHEV_DirectInput_plot_result_powersplit( nvpairs )
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

tl = tiledlayout(parent, 3, 3);

parent.Position(3:4) = [800 600];  % width height

ax = nexttile(tl);
vals = logsout.get("MG2 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG2 Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG2 Torque Command").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("MG2 Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlabel(ax, "Time (s)")
title(ax, "MG2 Torques (N*m)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG2 Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel(ax, "Time (s)")
title(ax, "MG2 Current (A)")
hold off



ax = nexttile(tl);
vals = logsout.get("MG1 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG1 Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG1 Torque Command").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("MG1 Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlabel(ax, "Time (s)")
title(ax, "MG1 Torques (N*m)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG1 Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel(ax, "Time (s)")
title(ax, "MG1 Current (A)")
hold off



ax = nexttile(tl);
vals = logsout.get("Engine Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Engine Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("Engine Torque Command").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("Engine Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlabel(ax, "Time (s)")
title(ax, "Engine Torques (N*m)")
hold off

ax = nexttile(tl);
vals = logsout.get("Axle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Axle Speed (rpm)")
hold off

end
