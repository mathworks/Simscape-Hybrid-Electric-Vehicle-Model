function PowerSplitHEV_resetReferencedSubsystems(modelName)
%% Resets system model with default referenced subsystems
% Consider this function as a tool to "factory reset" the referenced subsystems.

% Copyright 2022 The MathWorks, Inc.

arguments
  modelName {mustBeTextScalar} = "PowerSplitHEV_system_model"
end

load_system(modelName)

set_param( modelName + "/Controller & Environment", ...
  "ReferencedSubsystem", "PowerSplitHEV_SpeedTracking_refsub");

set_param( modelName + "/High Voltage Battery", ...
  "ReferencedSubsystem", "BatteryHVElec_refsub");

set_param( modelName + "/DC-DC Converter", ...
  "ReferencedSubsystem", "DcDcConverterElec_refsub");

set_param( modelName + "/Power Split Drive Unit", ...
  "ReferencedSubsystem", "PowerSplitDriveUnitBasic_refsub");

set_param( modelName + "/Longitudinal Vehicle", ...
  "ReferencedSubsystem", "Vehicle1DCustom_refsub");

save_system(modelName)

end  % function
