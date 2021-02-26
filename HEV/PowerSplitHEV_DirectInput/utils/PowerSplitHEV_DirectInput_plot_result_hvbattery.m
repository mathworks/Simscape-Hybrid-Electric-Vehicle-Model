function PowerSplitHEV_DirectInput_plot_result_hvbattery( nvpairs )
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

tl = tiledlayout(parent, 3, 2);

parent.Position(3:4) = [700 600];  % width height

ax = nexttile(tl);
vals = logsout.get("HV Battery Charge").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.02)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Charge (A*hr)")
hold off

ax = nexttile(tl);
vals = logsout.get("HV Battery Power").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.02)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Power (kW)")
hold off

ax = nexttile(tl);
vals = logsout.get("HV Battery Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("DC-DC Battery-Side Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Currents (A)")
hold off

ax = nexttile(tl);
vals = logsout.get("DC-DC Load-Side Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel(ax, "Time (s)")
title(ax, "DC-DC Load-Side Current (A)")
hold off

ax = nexttile(tl);
vals = logsout.get("HV Battery Voltage").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("DC-DC Battery-Side Voltage").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Voltages (V)")
hold off

ax = nexttile(tl);
vals = logsout.get("DC-DC Load-Side Voltage").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2)
xlabel(ax, "Time (s)")
title(ax, "DC-DC Load-Side Voltage (V)")
hold off

end
