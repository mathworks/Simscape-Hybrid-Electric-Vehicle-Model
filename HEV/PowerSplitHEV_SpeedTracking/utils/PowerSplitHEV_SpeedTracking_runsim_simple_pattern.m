%% Simulation Script for Power-Split HEV with Speed Tracking

% Copyright 2021 The MathWorks, Inc.

%% Setup external inputs

PowerSplitHEV_SpeedTracking_select_simple_pattern

%% Load default initial conditions and block parameter values

% Plant
PowerSplitHEV_params

% Controller/Driver - load this after plant
DriverHEVPowerSplit_params

%% Override initial conditions and block parameter values

initial_SOC_pct = initial_DrvPtn.HVBattery_SOC_pct;
% initial_SOC_pct = 75;

initial.hvBatteryCapacity_kWh = batteryHighVoltage.nominalCapacity_kWh * initial_SOC_pct/100;
initial.driverHVBattSOC_pct = initial_SOC_pct;

initial.driverBrakeForce_N = 8000;
initial.driverBrakeOn_tf = true;

initial.vehicleSpeed_kph = 0;
initial.motorGenerator2_speed_rpm = 0;
initial.motorGenerator1_speed_rpm = 0;
initial.engine_speed_rpm = 0;
initial.engine_torque_Nm = 0;

%% Set simulation input

in = Simulink.SimulationInput(mdl);
in = in.setModelParameter('StopTime',num2str(t_end));

%% Run simulation

disp("Running simulation for " + input_pattern)
out = sim(in);
