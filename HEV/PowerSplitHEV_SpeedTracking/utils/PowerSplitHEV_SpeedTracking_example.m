function PowerSplitHEV_SpeedTracking_example(inputPattern)
%% Shows image file of simulation result plot
% This function shows image file of simulation result plot
% corresponding to the specified input pattern.
% This function uses image file if it exists
% in a folder (hardcoded in this function), but if it does not exist,
% first runs simulation, saves plot figure in image file, and shows it.

% Copyright 2022 The MathWorks, Inc.

arguments
  inputPattern {mustBeTextScalar, mustBeMember(inputPattern, ...
    ["Accelerate_Decelerate", "SimpleDrivePattern", "FTP75"])} ...
    = "Accelerate_Decelerate"
end

mdl = "PowerSplitHEV_system_model";

pngFileName = "image_" + inputPattern + ".png";
prjRoot = currentProject().RootFolder;
imgPath = fullfile( ...
  prjRoot, "HEV", "PowerSplitHEV_SpeedTracking", "images", pngFileName);

if not(exist(imgPath, "file"))
% Run simulation and save image file of simulation result plot.

  if not(bdIsLoaded(mdl))
    load_system(mdl);
  end

  % Load defaults.
  PowerSplitHEV_params

  % Use speed tracking controller.
  set_param(mdl+"/Controller & Environment", "ReferencedSubsystem", ...
    "PowerSplitHEV_SpeedTracking_refsub")

  % This loads some variables in the base workspace.
  PowerSplitHEV_SpeedTracking_selectInput( "InputPattern", inputPattern )

  simOut = sim(mdl);

  fig = figure("Visible", "off");

  PowerSplitHEV_plot_result_compact("Dataset",simOut.logsout, "PlotParent",fig)

  exportgraphics(fig, imgPath)
end  % if

figure
imshow(imgPath)

end  % function
