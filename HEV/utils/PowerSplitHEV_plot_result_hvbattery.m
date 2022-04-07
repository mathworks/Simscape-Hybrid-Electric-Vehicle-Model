function PowerSplitHEV_plot_result_hvbattery( nvpair )
% Plots the simulation result.

% Copyright 2021 The MathWorks, Inc.

%% Process arguments

arguments
  nvpair.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpair.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpair.Dataset;
parent = nvpair.PlotParent;

%% Plot

parent.Position(3:4) = [700 500];  % width height

tl = tiledlayout(parent, 4, 2, ...
      'TileSpacing','compact', 'Padding','compact' );

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery SOC"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, 'dy_threshold',0.02)
xlabel(ax, "Time (s)")
title(ax, "HV Battery SOC (%)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery Current"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = getValuesFromLogsout(logsout.get("Battery-Side Current"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
setMinimumYRange(ax, vals.Data, 'dy_threshold',0.02)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Currents (A)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery Charge"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, 'dy_threshold',0.02)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Charge (A*hr)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery Voltage"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get("Battery-Side Voltage").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
setMinimumYRange(ax, vals.Data, 'dy_threshold',0.02)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Voltages (V)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery Charge Level (0/1/2/3)"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel(ax, "Time (s)")
title(ax, "HV Battery Charge Level (0/1/2/3)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Load-Side Current"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, 'dy_threshold',0.02)
xlabel(ax, "Time (s)")
title(ax, "DC-DC Load-Side Current (A)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("HV Battery Power"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, 'dy_threshold',0.02)
xlabel(ax, "Time (s)")
title(ax, "HV Battery Power (kW)")
hold off

ax = nexttile(tl);
vals = getValuesFromLogsout(logsout.get("Load-Side Voltage"));
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, 'dy_threshold',0.02)
xlabel(ax, "Time (s)")
title(ax, "DC-DC Load-Side Voltage (V)")
hold off

end  % function
