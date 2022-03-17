function PowerSplitDriveUnit_plot_results(logsout)

% Copyright 2022 The MathWorks, Inc.

arguments
  logsout (1,1) Simulink.SimulationData.Dataset
end

fig = figure;
fig.Position(3:4) = [800 200];
PowerSplitDriveUnit_plot_vehicle("Dataset",logsout, "PlotParent",fig);

fig = figure;
fig.Position(3:4) = [800 600];
PowerSplitDriveUnit_plot_psdu("Dataset",logsout, "PlotParent",fig);

fig = figure;
fig.Position(3:4) = [800 400];
PowerSplitDriveUnit_plot_hvbattery("Dataset",logsout, "PlotParent",fig);

end  % function
