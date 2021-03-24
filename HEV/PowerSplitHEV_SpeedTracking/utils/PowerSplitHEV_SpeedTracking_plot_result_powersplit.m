function PowerSplitHEV_SpeedTracking_plot_result_powersplit( nvpair )
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

tl = tiledlayout(parent, 4, 3, ...
      'TileSpacing','compact', 'Padding','compact' );

parent.Position(3:4) = [800 700];  % width height

ax = nexttile(tl);
vals = logsout.get("MG2 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG2 Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("Engine Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Engine Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("MG1 Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG1 Speed (rpm)")
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
vals = logsout.get("Engine Torque Command").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("Engine Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlabel(ax, "Time (s)")
title(ax, "Engine Torques (N*m)")
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
vals = logsout.get("MG2 Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG2 Current (A)")
hold off

ax = nexttile(tl);
vals = logsout.get("Engine for Driving").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Engine for Driving")
hold off

ax = nexttile(tl);
vals = logsout.get("MG1 Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG1 Current (A)")
hold off


ax = nexttile(tl);
vals = logsout.get("MG2 Regen On Off").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "MG2 Regen On Off")
hold off

ax = nexttile(tl);
vals = logsout.get("Engine for Generating").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Engine for Generating")
hold off

end
