function PowerSplitHEV_resetReferencedSubsystems(modelName)
%% Resets system model with default referenced subsystems
% Consider this function as a tool to "factory reset" the referenced subsystems.

% Copyright 2022 The MathWorks, Inc.

arguments
  modelName {mustBeTextScalar} = "PowerSplitHEV_system_model"
end

load_system(modelName)

refSubName = "PowerSplitHEV_SpeedTracking_refsub";
checkModelFileExists(refSubName)
set_param( modelName + "/Controller & Environment", ...
  ReferencedSubsystem = refSubName);

refSubName = "BatteryHV_refsub_Electrical";
checkModelFileExists(refSubName)
set_param( modelName + "/High Voltage Battery", ...
  ReferencedSubsystem = refSubName);

refSubName = "DcDcConverterElec_refsub";
checkModelFileExists(refSubName)
set_param( modelName + "/DC-DC Converter", ...
  ReferencedSubsystem = refSubName);

refSubName = "PowerSplitDriveUnitBasic_refsub";
checkModelFileExists(refSubName)
set_param( modelName + "/Power Split Drive Unit", ...
  ReferencedSubsystem = refSubName);

refSubName = "Vehicle1D_refsub_Driveline"; 
checkModelFileExists(refSubName)
set_param( modelName + "/Longitudinal Vehicle", ...
  ReferencedSubsystem = refSubName);

save_system(modelName)

end  % function

function checkModelFileExists(modelName)

arguments
  % File extension (.mdl or .slx) is not necessary.
  modelName {mustBeTextScalar}
end

pathToFile = which(modelName);

if isempty(pathToFile)
  error("Model not found: " + modelName)
end

end  % function
