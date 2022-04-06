%% Setup Script for Power-Split HEV with Speed Tracking

% Copyright 2021 The MathWorks, Inc.

%% Load drive pattern

inputPattern = "Accelerate_Decelerate";
% inputPattern = "SimpleDrivePattern";
% inputPattern = "FTP75";

% This loads some variables in the base workspace.
PowerSplitHEV_SpeedTracking_selectInput( ...
  "InputPattern", inputPattern, ...
  "DisplayMessage", false );

%% Load default parameters

PowerSplitHEV_params

%% Override defaults

tmp_initial_SOC_pct = 75;

initial.hvBatteryCapacity_kWh = ...
  batteryHighVoltage.nominalCapacity_kWh * tmp_initial_SOC_pct/100;

initial.controllerHVBattSOC_pct = tmp_initial_SOC_pct;

initial.driverBrakeForce_N = 8000;
initial.driverBrakeOn_tf = true;

initial.vehicleSpeed_kph = 0;
initial.motorGenerator2_speed_rpm = 0;
initial.motorGenerator1_speed_rpm = 0;
initial.engine_speed_rpm = 0;
initial.engine_torque_Nm = 0;
