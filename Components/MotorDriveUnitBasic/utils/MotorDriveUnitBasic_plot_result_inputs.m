function MotorDriveUnitBasic_plot_result_inputs(nvpairs)
% plots the simulation result.

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpairs.Dataset;
parent = nvpairs.PlotParent;

%%
parent.Position(3:4) = [600 400];  % width height

tl = tiledlayout(parent, 2, 1);

ax = nexttile(tl);
vals = logsout.get("Rotor Torque Input").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel("Time (s)")
title("Torque Input to Motor Rotor (N*m)")
hold off

ax = nexttile(tl);
vals = logsout.get("Torque Command Input").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel("Time (s)")
title("Torque Command Input to Motor Drive Unit (N*m)")
hold off

end
