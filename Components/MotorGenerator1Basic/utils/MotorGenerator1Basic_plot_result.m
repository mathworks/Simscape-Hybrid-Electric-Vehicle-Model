function MotorGenerator1Basic_plot_result(nvpairs)
% plots the simulation result.

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.Dataset (1,1) Simulink.SimulationData.Dataset
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

logsout = nvpairs.Dataset;
parent = nvpairs.PlotParent;

%%
parent.Position(3:4) = [600 500];  % width height

tl = tiledlayout(parent, 2, 2);

signame = "MG1 Speed";
unitstr = "(rpm)";
ax = nexttile(tl);
vals = logsout.get(signame).Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel("Time (s)")
title(signame + " " + unitstr)
hold off

signame = "Engine Speed";
unitstr = "(rpm)";
ax = nexttile(tl);
vals = logsout.get(signame).Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
xlabel("Time (s)")
title(signame + " " + unitstr)
hold off


signame = "MG1 Torque";
unitstr = "(N*m)";
ax = nexttile(tl);
vals = logsout.get(signame).Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get(signame + " Command").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlabel("Time (s)")
title(signame + " " + unitstr)
hold off

signame = "Engine Torque";
unitstr = "(N*m)";
ax = nexttile(tl);
vals = logsout.get(signame).Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
hold on;  grid on
vals = logsout.get(signame + " Command").Values;
plot(ax, vals.Time, vals.Data, 'LineWidth',2)
xlabel("Time (s)")
title(signame + " " + unitstr)
hold off

end
