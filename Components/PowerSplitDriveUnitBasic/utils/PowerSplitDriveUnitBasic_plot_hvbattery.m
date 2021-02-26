function PowerSplitDriveUnitBasic_plot_hvbattery(nvpairs)

% Copyright 2020-2021 The MathWorks, Inc.

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

if isfield(nvpairs, 'Dataset')
  logsout = nvpairs.Dataset;
else
  error("Dataset must be specified")
end
if isfield(nvpairs, 'PlotParent')
  parent = nvpairs.PlotParent;
else
  error("PlotParent must be specified")
end

parent.Position(3:4) = [800 400];  % width height

tl = tiledlayout(parent, 2, 2);

ax = nexttile(tl);
vals = logsout.get("HV Battery Current").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "HV Battery Current (A)")
hold off

ax = nexttile(tl);
vals = logsout.get("HV Battery Voltage").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "HV Battery Voltage (V)")
hold off


ax = nexttile(tl);
vals = logsout.get("HV Battery Power").Values;
plot(ax, vals.Time, vals.Data/1000, 'LineWidth',2)  % in kW
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "HV Battery Power (kW)")
hold off

ax = nexttile(tl);
vals = logsout.get("HV Battery Net Charge").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
setMinimumYRange(ax, vals.Data, "dy_threshold",0.2);
xlabel(ax, "Time (s)")
title(ax, "HV Battery Net Charge (A*hr)")
hold off

end  % function
