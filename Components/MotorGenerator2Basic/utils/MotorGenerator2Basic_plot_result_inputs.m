function MotorGenerator2Basic_plot_result_inputs_trq( nvpairs )
% plots the input signals logged in simulation.

% Copyright 2021 The MathWorks, Inc.

%% Process arguments

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpairs.Dataset;
parent = nvpairs.PlotParent;

%% Plot

tl = tiledlayout(parent, 4, 1);

ax = nexttile(tl);
vals = logsout.get("Rotor Speed Input On Off").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Rotor Speed Input On Off (1)")
hold off

ax = nexttile(tl);
vals = logsout.get("Rotor Speed Input").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Rotor Speed Input (rpm)")
hold off

ax = nexttile(tl);
vals = logsout.get("Rotor Torque Input").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Rotor Torque Input (N*m)")
hold off

ax = nexttile(tl);
vals = logsout.get("Torque Command Input").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "Torque Command Input (N*m)")
hold off

end
