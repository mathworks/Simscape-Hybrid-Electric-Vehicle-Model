function MotorGenerator2Basic_plot_result_outputs( nvpairs )
% plots the output signals logged in simulation.

% Copyright 2021 The MathWorks, Inc.

%% Process arguments

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpairs.Dataset;
parent = nvpairs.PlotParent;

%% Plot

tl = tiledlayout(parent, 4, 2);

ax = nexttile(tl);
vals = logsout.get("Longitudinal Velocity").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2)
xlabel(ax, "Time (s)")
title(ax, "Longitudinal Velocity (km/hr)")
hold off

ax = nexttile(tl);
vals = logsout.get("Traveled Distance").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel("Time (s)")
title("Traveled Distance (km)")
hold off



ax = nexttile(tl);
vals = logsout.get("Axle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2)
xlabel(ax, "Time (s)")
title(ax, "Axle Speed (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("Axle Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel("Time (s)")
title("Axle Torque (N*m)")
hold off



ax = nexttile(tl);
vals = logsout.get("Motor Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
yline(evalin('base','motorGenerator2.spdMax_rpm'), 'LineWidth',2)
setMinimumYRange(ax, vals.Data, "dy_threshold",2)
xlabel(ax, "Time (s)")
title(ax, "Motor Speed (rpm)")
legend(["Actual", "Upper limit"], "location","best")
hold off

ax = nexttile(tl);
vals = logsout.get("Motor Torque").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("Torque Command Input").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel("Time (s)")
title("Motor Torques (N*m)")
legend(["Actual", "Command"], "location","best")
hold off



ax = nexttile(tl);
vals = logsout.get("Motor Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2)
xlabel(ax, "Time (s)")
title(ax, "Motor Current (A)")
hold off

end
