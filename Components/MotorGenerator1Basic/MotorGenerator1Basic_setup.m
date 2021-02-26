%% Setup Script for Motor Generator 1

% Copyright 2021 The MathWorks, Inc.

%% Inputs

[inputSignals_testMG1, inputBus_testMG1, t_end] = ...
  MotorGenerator1Basic_inputs( "InputPattern","generate" );

%% Parameters

PowerSplitHEV_params

%% Initial Conditions

initial.motorGenerator1_speed_rpm = 0;
initial.vehicleSpeed_kph = 0;

%% Block Parameters

testharness.batteryVoltage_V = 650;
testharness.batteryInternalR_Ohm = 0.1;

% Gear reduction from MG1 to axle.
% In the actual vehicle powertrain configuration, MG1 rotates in reverse to
% drive the axle, but this test model has a simple configuration where
% MG1 should rotate in the positive direction to drive the axle.
vehicle.reducer_ratio = 78/30 * 53/65 * 73/21;  % 7.3695
vehicle.mass_kg = 1500;
vehicle.tireRollingRadius_m = 0.3;
vehicle.friction_Nm_per_rpm = 1;


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
