%% Setup Script for Motor Generator 2

% Copyright 2021 The MathWorks, Inc.

[inputSignals_MG2, inputBus_MG2, t_end] = ...
  MotorGenerator2Basic_inputs("InputPattern","torque_drive");


initial.motorGenerator2_speed_rpm = 0;
initial.vehicleSpeed_kph = 0;


testharness.batteryVoltage_V = 650;
testharness.batteryInternalR_Ohm = 0.05;

testharness.vehicleMass_kg = 1500;
testharness.tireRollingRadius_m = 0.3;
testharness.reducerGearRatio_1 = 53/17 * 73/21;  % HEV 53/17*73/21 = 10.8375
testharness.geartrainFriction_Nm_per_rpm = 0.01;


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
