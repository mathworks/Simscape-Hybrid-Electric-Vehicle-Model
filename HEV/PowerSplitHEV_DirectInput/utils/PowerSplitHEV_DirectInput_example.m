function PowerSplitHEV_DirectInput_example(inputPattern)
%% Shows image file of simulation result plot
% This function shows image file of simulation result plot
% corresponding to the specified input pattern.
% This function uses image file if it exists
% in a folder (hardcoded in this function), but if it does not exist,
% first runs simulation, saves plot figure in image file, and shows it.

% Copyright 2022 The MathWorks, Inc.

arguments
  inputPattern {mustBeTextScalar, mustBeMember(inputPattern, ...
    [ "Constant" ...
      "Downhill" ...
      "Downhill_2" ...
      "EngineDrive" ...
      "MG1Drive" ...
      "MG2Drive" ...
      "MG2Drive_2" ...
      "MG2Drive_StartEngine" ...
      "MG2Drive_StartEngine_2" ...
      "Parked_EngineChargeBattery" ...
      "PowerSplitDrive"])} ...
    = "PowerSplitDrive"
end

mdl = "PowerSplitHEV_system_model";

pngFileName = "image_" + inputPattern + ".png";
prjRoot = currentProject().RootFolder;
imgPath = fullfile( ...
  prjRoot, "HEV", "PowerSplitHEV_DirectInput", "images", pngFileName);

if not(exist(imgPath, "file"))
% Run simulation and save image file of simulation result plot.

  if not(bdIsLoaded(mdl))
    load_system(mdl);
  end

  % Load defaults.
  PowerSplitHEV_params

  % Use direct torque input.
  set_param(mdl+"/Controller & Environment", "ReferencedSubsystem", ...
    "PowerSplitHEV_DirectInput_refsub")

  % From inputPattern string, get function name so that it can be passed to selectInput.
  % The inputPattern can consist of the function name followed by '_2', '_3', and so on.
  pat = "_" + digitsPattern;
  if endsWith(inputPattern, pat)
    inputPattern_core = extractBefore(inputPattern, pat);
  else
    inputPattern_core = inputPattern;
  end

  % This loads some variables in the base workspace.
  PowerSplitHEV_DirectInput_selectInput( "InputPattern", inputPattern_core )

  simOut = sim(mdl);

  fig = figure("Visible", "off");

  PowerSplitHEV_plot_result_compact("Dataset",simOut.logsout, "PlotParent",fig)

  exportgraphics(fig, imgPath)
end  % if

figure
imshow(imgPath)

end  % function
