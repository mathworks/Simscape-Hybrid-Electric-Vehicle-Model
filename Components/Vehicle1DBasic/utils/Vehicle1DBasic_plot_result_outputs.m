function Vehicle1DBasic_plot_result_outputs(nvpairs)
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
parent.Position(3:4) = [600 400];  % width height

tl = tiledlayout(parent, 2,1);

ax = nexttile(tl);
vals = logsout.get("Vehicle Speed").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",2);
xlabel(ax, "Time (s)")
title(ax, "Vehicle Speed (km/hr)")
hold off

ax = nexttile(tl);
vals = logsout.get("G-Force").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.02);
xlabel("Time (s)")
title("G-Force (-)")
hold off

end
