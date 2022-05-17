%% Parameters for Power-Split HEV System
% Parameters in this script are for a small sedan-type hybrid car.

% Copyright 2021-2022 The MathWorks, Inc.

%% Load bus defition

defineBus_HighVoltage

%% Ambient
% These parameters are used when thermal model is enabled
% somewhere in the model, such as in the Battery component.
% These are not used by the Basic version of the referenced subsystems.

ambient.mass_t = 10000;  % tonnes
ambient.SpecificHeat_J_per_Kkg = 1000;
ambient.temp_K = 273.15 + 20;

initial.ambientTemp_K = ambient.temp_K;

%% Vehicle

% Curb weight + fuel + load
vehicle.mass_kg = 1400 + 50*0.7 + 70*2;  % 1575

vehicle.tireRollingRadius_m = 0.3;
vehicle.roadLoadA_N = 175;  % A = tire_rolling_coefficient * mass * g
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.032;  % C = 0.5 * Cd * frontal_area * air_density
vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

smoothing.vehicle_speedThreshold_kph = 1;
smoothing.vehicle_axleSpeedThreshold_rpm = 1;

initial.vehicle_speed_kph = 0;

%% High Voltage Battery

% **Essential**
batteryHV.nominalVoltage_V = 200;
batteryHV.internalResistance_Ohm = 0.01;
batteryHV.nominalCapacity_kWh = 25;
batteryHV.voltagePerCell_V = 3.7;  % Open Circuit Voltage. 3.5V to 3.7V assuming Lithium-ion

batteryHV.nominalCharge_Ahr = ...
  batteryHV.nominalCapacity_kWh / batteryHV.nominalVoltage_V * 1000;

% Assertion block stops simulation with this bound.
% batteryHV_SOC_LowerBound_pct = 2;

% Initial conditions
initial.hvBattery_SOC_pct = 70;
initial.hvBattery_Charge_Ahr = batteryHV.nominalCharge_Ahr * initial.hvBattery_SOC_pct/100;

% **Finite Capacity Battery**
% At SOC 50%, voltage is 90% of the nominal.
batteryHV.measuredCharge_Ahr = batteryHV.nominalCharge_Ahr * 0.5;
batteryHV.measuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;

batteryHV.RadiationArea_m2 = 1;
batteryHV.RadiationCoeff_W_per_K4m2 = 5e-10;

batteryHV.thermalMass_kJ_per_K = 0.1;

initial.hvBattery_Temperature_K = ambient.temp_K;

% **More Thermal model parameters**
% These parameters are used when thermal model is enabled
% in the Battery block from Simscape Electrical.
batteryHV.measurementTemperature_K = 273.15 + 25;
batteryHV.secondMeasurementTemperature_K = 273.15 + 0;
batteryHV.secondNominalVoltage_V = batteryHV.nominalVoltage_V * 0.95;
batteryHV.secondInternalResistance_Ohm = batteryHV.internalResistance_Ohm * 2;
batteryHV.secondMeasuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;

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

smoothing.planetary_meshing_loss_thresholds_W = [10, 10];

smoothing.gear_meshing_loss_threshold_W = 10;

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
motorGenerator2.dampSpringStiffness_Nm_per_rad = 10000;
motorGenerator2.dampSpringFriction_Nm_per_rpm = 100;

smoothing.mg2_dampSpringVelTol_rpm = 0.1;

initial.motorGenerator2_speed_rpm = 0;

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
motorGenerator1.dampSpringStiffness_Nm_per_rad = 10000;
motorGenerator1.dampSpringFriction_Nm_per_rpm = 100;

smoothing.mg1_dampSpringVelTol_rpm = 0.1;

initial.motorGenerator1_speed_rpm = 0;

%% Engine

engine.trqMax_Nm = 145;
engine.trqMaxSpd_rpm = 3500;
engine.powerMax_kW = 75;

engine.maxSpd_rpm = 7000;
engine.stallSpd_rpm = 500;
engine.smoothing_rpm = 100;

engine.lag_s = 0.1;

engine.inertia_kg_m2 = 0.02;

engine.damping_Nm_per_rpm = 0.02;
engine.dampSpringStiffness_Nm_per_rad = 10000;
engine.dampSpringFriction_Nm_per_rpm = 100;

smoothing.engine_dampSpringVelTol_rpm = 0.1;

initial.engine_speed_rpm = 0;
initial.engine_torque_Nm = 0;

%% Parameters for Controller

% Run the following script after loading parameters for plant.
% Direct torque input does not need this, but it is always loaded for simplicity.
HEVPowerSplitControl_params
