%% Setup Script for Power Split Drive Unit

% Copyright 2021 The MathWorks, Inc.

%% Input signals

[inputSignals_PSDU, inputBus_PSDU, t_end] = ...
  PowerSplitDriveUnitBasic_inputs("InputPattern", "power_split_drive");

%% Initial conditions
initial.vehicleSpeed_kph = 0;
initial.motorGenerator2_speed_rpm = 0;
initial.motorGenerator1_speed_rpm = 0;
initial.engine_speed_rpm = 0;
initial.engine_torque_Nm = 0;

%% Block parameters

testharness.batteryVoltage_V = 650;
testharness.batteryInternalR_Ohm = 0.05;

testharness.vehicleMass_kg = 1500;
testharness.tireRollingRadius_m = 0.3;
testharness.geartrainFriction_Nm_per_rpm = 0.01;

% In the test harness model of the power-split drive unit,
% the gear ratio for the vehicle component is set to 1
% because all the gears are modeled in the drive unit model.
testharness.reducerGearRatio_1 = 1;

powerSplit.reducer_counterDriveGearRatio = 53/65;  % 53/65 = 0.8154  P610
powerSplit.reducer_MG2GearRatio = 53/17;  % 53/17 = 3.1176  P610 motor reduction gear ratio
powerSplit.reducer_differentialGearRatio = 21/73;  % HEV
powerSplit.reducer_efficiency = 0.98;
powerSplit.reducer_friction_Nm_per_rpm = [0.001 0.001];  % Base and Follower
powerSplit.reducer_inertia_kg_m2 = 0.001;

powerSplit.planetary_ringToSunGearRatio = 78/30;  % 78/30 == 2.6
powerSplit.planetary_efficiencies = [0.98, 0.98];  % S-P, R-P
powerSplit.planetary_frictions_Nm_per_rpm = [0.001 0.001];  % S-C, P-C frictions
powerSplit.planetary_planetGearInertia_kg_m2 = 0.001;
powerSplit.planetary_ringInertia_kg_m2 = 0.001;

motorGenerator2.trqMax_Nm = 163;  % P610
motorGenerator2.spdMax_rpm = 17000;  % P610
motorGenerator2.powerMax_kW = 53;  % P610
motorGenerator2.responseTime_s = 0.02;
motorGenerator2.efficiency_pct = 98;
motorGenerator2.spd_eff_rpm = 2000;
motorGenerator2.trq_eff_Nm = 50;
motorGenerator2.iron_loss_to_nominal_ratio = 0.1;
motorGenerator2.elecLossConst_W = 30;
motorGenerator2.rotorInertia_kg_m2 = 0.001;
motorGenerator2.kDamp_Nm_per_radPerS = 0.005;

motorGenerator1.trqMax_Nm = 40;  % P610
motorGenerator1.spdMax_rpm = 10000;  % P610
motorGenerator1.powerMax_kW = 23;  % P610
motorGenerator1.responseTime_s = 0.02;
motorGenerator1.efficiency_pct = 95;
motorGenerator1.spd_eff_rpm = 2000;
motorGenerator1.trq_eff_Nm = 20;
motorGenerator1.iron_loss_to_nominal_ratio = 0.1;
motorGenerator1.elecLossConst_W = 20;
motorGenerator1.rotorInertia_kg_m2 = 0.001;
motorGenerator1.kDamp_Nm_per_radPerS = 0.005;

engine.maxTrq_Nm = 142;  % 2016 Prius 2ZR-FXE, 1.8 Liter
engine.lag_s = 0.1;
engine.inertia_kg_m2 = 0.001;
engine.damping_Nm_per_rpm = 0.02;
