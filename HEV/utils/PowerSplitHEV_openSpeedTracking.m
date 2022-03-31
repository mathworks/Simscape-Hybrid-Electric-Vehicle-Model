function PowerSplitHEV_openSpeedTracking(modelName, nvpairs)
%% Open Power-Split HEV model with Speed Tracking controller

% Copyright 2022 The MathWorks, Inc.

arguments
  modelName {mustBeTextScalar}
  nvpairs.DisplayMessage (1,1) logical = false
end

if nvpairs.DisplayMessage
  disp("Opening Model: " + modelName + " for Speed Tracking")
end

if not(bdIsLoaded(modelName))
  load_system(modelName)
end

set_param(modelName+"/Controller & Environment", "ReferencedSubsystem", ...
  "PowerSplitHEV_SpeedTracking_refsub");

open_system(modelName)

end
