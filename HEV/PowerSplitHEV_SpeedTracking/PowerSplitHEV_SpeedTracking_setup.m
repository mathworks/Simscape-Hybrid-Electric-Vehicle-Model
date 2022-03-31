%% Setup Script for Power-Split HEV with Speed Tracking

% Copyright 2021 The MathWorks, Inc.

%% Load drive pattern

inputPatternStr = "accelerate_decelerate_kph";
% inputPatternStr = "simple_drive_pattern";
% inputPatternStr = "ftp75_mph";

PowerSplitHEV_SpeedTracking_selectInput( ...
  "InputPattern", inputPatternStr, ...
  "DisplayMessage", false );

%% Load default parameters

% Plant
PowerSplitHEV_params

%% Override initial conditions and block parameter values

% initial_SOC_pct = initial_DrvPtn.HVBattery_SOC_pct;
initial_SOC_pct = 75;

initial.hvBatteryCapacity_kWh = batteryHighVoltage.nominalCapacity_kWh * initial_SOC_pct/100;
initial.driverHVBattSOC_pct = initial_SOC_pct;

initial.driverBrakeForce_N = 8000;
initial.driverBrakeOn_tf = true;

initial.vehicleSpeed_kph = 0;
initial.motorGenerator2_speed_rpm = 0;
initial.motorGenerator1_speed_rpm = 0;
initial.engine_speed_rpm = 0;
initial.engine_torque_Nm = 0;
