%% Parameters for Power-Split HEV System

% Copyright 2021 The MathWorks, Inc.

%% Initial conditions

initial.hvbatterySOC_pct = 95;

initial.brakeForce_N = 8000;
initial.brakeOn_tf = true;

initial.vehicleSpeed_kph = 0;
initial.motorGenerator2_speed_rpm = 0;
initial.motorGenerator1_speed_rpm = 0;
initial.engine_speed_rpm = 0;
initial.engine_torque_Nm = 0;

%% Vehicle

vehicle.mass_kg = 1790;  % 2016 Toyota Prius (XW50, P610)
vehicle.tireRollingRadius_m = 0.3;
vehicle.roadLoadA_N = 175;
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.032;
vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

%% High Voltage Battery

batteryHighVoltage.capacity_Ahr = 30;  % 2016 Prius: 6.5 Ahr (NiMH), or 3.6 Ahr (Li-ion)
batteryHighVoltage.voltage_V = 200;  % 2016 Prius: 201.6 V (168 cells), or 207.2 V (56 cells)
batteryHighVoltage.internal_R_Ohm = 0.1;

%% DC-DC Converter

dcDcConverter.outputVoltageRef_V = 650;  % Output voltage is probably not a constant in THS.
dcDcConverter.outputPower_kW = 250;
dcDcConverter.maxSupplyCurrent_A = 500;
dcDcConverter.efficiency_pct = 99;
dcDcConverter.fixedLoss_W = 10;
dcDcConverter.timeConstant_s = 0.02;

%% Power-Split Device

powerSplit.reducer_counterDriveGearRatio = 53/65;  % 53/65==0.8154  P610
powerSplit.reducer_MG2GearRatio = 53/17;  % 53/17==3.1176  P610
powerSplit.reducer_differentialGearRatio = 21/73;  % 73/21==3.4762  P610-HEV
powerSplit.reducer_efficiency = 0.98;
powerSplit.reducer_friction_Nm_per_rpm = [0.001, 0.001];  % base, follower
powerSplit.reducer_inertia_kg_m2 = 0.001;

powerSplit.planetary_ringToSunGearRatio = 78/30;  % 78/30==2.6
powerSplit.planetary_efficiencies = [0.98, 0.98];  % S-P, R-P
powerSplit.planetary_frictions_Nm_per_rpm = [0.001, 0.001];  % S-C, P-C frictions
powerSplit.planetary_planetGearInertia_kg_m2 = 0.001;
powerSplit.planetary_ringInertia_kg_m2 = 0.001;

%% Motor-Generator 2

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

%% Motor-Generator 1

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

%% Engine

engine.trqMax_Nm = 142;  % 2016 Prius 2ZR-FXE, 1.8 Liter
engine.lag_s = 0.1;
engine.inertia_kg_m2 = 0.001;
engine.damping_Nm_per_rpm = 0.02;
