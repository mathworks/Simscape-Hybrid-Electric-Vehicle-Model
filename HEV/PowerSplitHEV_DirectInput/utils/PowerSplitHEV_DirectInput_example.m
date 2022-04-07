function PowerSplitHEV_DirectInput_example(inputPattern)
%% Run simulation and make plots
% This function runs simulation for a specified drive pattern/cycle
% with default settings and makes the plots of selected quantities.

% Copyright 2022 The MathWorks, Inc.

arguments
  inputPattern {mustBeTextScalar, mustBeMember(inputPattern, ...
    ["PowerSplitDrive", "MG2Drive", "EngineDrive", "MG1Drive", "Downhill"])} ...
    = "PowerSplitDrive"
end

mdl = "PowerSplitHEV_system_model";

if not(bdIsLoaded(mdl))
  load_system(mdl);
end

% Load defaults.
PowerSplitHEV_params

% Use direct torque input.
set_param(mdl+"/Controller & Environment", "ReferencedSubsystem", ...
  "PowerSplitHEV_DirectInput_refsub")

% This loads some variables in the base workspace.
PowerSplitHEV_DirectInput_selectInput( ...
  "InputPattern", inputPattern, ...
  "DisplayMessage", false )

simOut = sim(mdl);

fig = figure;
PowerSplitHEV_plot_result_compact( ...
  "Dataset",simOut.logsout, "PlotParent",fig )

end  % function
