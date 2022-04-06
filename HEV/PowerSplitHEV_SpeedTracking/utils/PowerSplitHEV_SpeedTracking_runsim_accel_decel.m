%% Simulation Script for Power-Split HEV with Speed Tracking

% Copyright 2021-2022 The MathWorks, Inc.

modelName = "PowerSplitHEV_system_model";

if not(bdIsLoaded(modelName))
  load_system(modelName)
end

%% Setup external inputs

PowerSplitHEV_SpeedTracking_select_accel_decel

% t_end should have been loaded.
disp("Simulation stop time: " + t_end)

%% Load default initial conditions and block parameter values

PowerSplitHEV_params

%% Override initial conditions and block parameter values

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

%% Set simulation input

in = Simulink.SimulationInput(modelName);
in = in.setModelParameter('StopTime', num2str(t_end));

%% Run simulation

disp("Running simulation...")
out = sim(in);
