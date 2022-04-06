function PowerSplitHEV_SpeedTracking_example(inputPattern)
%% Run simulation and make plots
% This function runs simulation for a specified drive pattern/cycle
% with default settings and makes the plots of selected quantities.

% Copyright 2022 The MathWorks, Inc.

arguments
  inputPattern {mustBeTextScalar} = "Accelerate_Decelerate"
end

mdl = "PowerSplitHEV_system_model";

if not(bdIsLoaded(mdl))
  load_system(mdl);
end

% Load defaults.
PowerSplitHEV_params

% Use speed tracking controller.
set_param(mdl+"/Controller & Environment", "ReferencedSubsystem", ...
  "PowerSplitHEV_SpeedTracking_refsub");

% This loads some variables in the base workspace.
PowerSplitHEV_SpeedTracking_selectInput( ...
  "InputPattern", inputPattern, ...
  "DisplayMessage", false );

simOut = sim(mdl);

fig = figure;
PowerSplitHEV_SpeedTracking_plot_result_compact( ...
  "Dataset",simOut.logsout, "PlotParent",fig );

end  % function
