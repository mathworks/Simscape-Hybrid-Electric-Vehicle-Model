%% Parameters for Power-Split HEV System
% Parameters in this script are for a small sedan-type hybrid car.

% Copyright 2021 The MathWorks, Inc.

%% Vehicle

% Curb weight + fuel + load
vehicle.mass_kg = 1400 + 50*0.7 + 70*2;  % 1575

vehicle.tireRollingRadius_m = 0.3;
vehicle.roadLoadA_N = 175;  % A = tire_rolling_coefficient * mass * g
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.032;  % C = 0.5 * Cd * frontal_area * air_density
vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

%% High Voltage Battery

batteryHighVoltage.nominalCapacity_kWh = 4;
batteryHighVoltage.voltagePerCell_V = 3.7;  % 3.5V to 3.7V assuming Lithium-ion
batteryHighVoltage.nominalCharge_Ah = ...
  batteryHighVoltage.nominalCapacity_kWh / batteryHighVoltage.voltagePerCell_V * 1000;

batteryHighVoltage.packVoltage_V = 200;
batteryHighVoltage.internal_R_Ohm = 0.1;

%% DC-DC Converter

% Constant boost voltage is used in this model.
dcDcConverter.outputVoltageRef_V = 650;

dcDcConverter.outputPower_kW = 250;
dcDcConverter.maxSupplyCurrent_A = 500;
dcDcConverter.efficiency_pct = 99;
dcDcConverter.fixedLoss_W = 10;
dcDcConverter.timeConstant_s = 0.02;

%% Power-Split Device

powerSplit.reducer_counterDriveGearRatio = 53/65;
powerSplit.reducer_MG2GearRatio = 53/17;
powerSplit.reducer_differentialGearRatio = 21/73;
powerSplit.reducer_efficiency = 0.98;
powerSplit.reducer_friction_Nm_per_rpm = [0.001, 0.001];  % base, follower
powerSplit.reducer_inertia_kg_m2 = 0.001;

powerSplit.planetary_ringToSunGearRatio = 78/30;
powerSplit.planetary_efficiencies = [0.98, 0.98];  % Sun-Planet, Ring-Planet
powerSplit.planetary_frictions_Nm_per_rpm = [0.001, 0.001];  % Sun-Carrier, Planet-Carrier frictions
powerSplit.planetary_planetGearInertia_kg_m2 = 0.001;
powerSplit.planetary_ringInertia_kg_m2 = 0.001;

%% Motor-Generator 2

motorGenerator2.trqMax_Nm = 165;
motorGenerator2.spdMax_rpm = 17000;
motorGenerator2.powerMax_kW = 55;
motorGenerator2.responseTime_s = 0.05;
motorGenerator2.efficiency_pct = 98;
motorGenerator2.spd_eff_rpm = 2000;
motorGenerator2.trq_eff_Nm = 50;
motorGenerator2.iron_loss_to_nominal_ratio = 0.1;
motorGenerator2.elecLossConst_W = 30;
motorGenerator2.rotorInertia_kg_m2 = 0.002;
motorGenerator2.kDamp_Nm_per_radPerS = 0.005;

%% Motor-Generator 1

motorGenerator1.trqMax_Nm = 40;
motorGenerator1.spdMax_rpm = 10000;
motorGenerator1.powerMax_kW = 25;
motorGenerator1.responseTime_s = 0.05;
motorGenerator1.efficiency_pct = 95;
motorGenerator1.spd_eff_rpm = 2000;
motorGenerator1.trq_eff_Nm = 20;
motorGenerator1.iron_loss_to_nominal_ratio = 0.1;
motorGenerator1.elecLossConst_W = 20;
motorGenerator1.rotorInertia_kg_m2 = 0.002;
motorGenerator1.kDamp_Nm_per_radPerS = 0.005;

%% Engine

engine.trqMax_Nm = 145;
engine.lag_s = 0.1;
engine.inertia_kg_m2 = 0.02;
engine.damping_Nm_per_rpm = 0.02;

%% Initial conditions
% These are for plant only.
% ICs for controller/driver are defined elsewhere.

initial.highVoltageBatterySOC_pct = 85;
initial.hvBatteryCharge_Ah = batteryHighVoltage.nominalCharge_Ah * initial.highVoltageBatterySOC_pct/100;

initial.vehicleSpeed_kph = 0;
initial.motorGenerator2_speed_rpm = 0;
initial.motorGenerator1_speed_rpm = 0;
initial.engine_speed_rpm = 0;
initial.engine_torque_Nm = 0;

%% Simulation smoothing parameters

smoothing.planetary_meshing_loss_thresholds_W = [10, 10];

smoothing.gear_meshing_loss_threshold_W = 10;

smoothing.vehicle_speed_threshold_kph = 1;
smoothing.axle_speed_threshold_rpm = 1;
