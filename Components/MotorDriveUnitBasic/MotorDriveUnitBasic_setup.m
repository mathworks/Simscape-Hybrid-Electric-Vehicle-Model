%% Setup Script for Motor Drive Unit

% Copyright 2021 The MathWorks, Inc.

%% Input signals

% MotorDriveUnitCustom_testinputs
[inputSignals_MotorDriveUnit, inputBus_MotorDriveUnit, t_end] = ...
  MotorDriveUnitBasic_inputs( "InputPattern","drive" );

%% Initial conditions

initial.motorDriveUnit_spd_rpm = 0;

%% Parameters

batteryHighVoltage.capacity_Ahr = 2500;  % about 9kWh in Li-ion (3.5V-3.7V cell)
batteryHighVoltage.voltage_V = 650;
batteryHighVoltage.internal_R_Ohm = 0.1;

motorDriveUnit.trqMax_Nm = 163;
motorDriveUnit.spdMax_rpm = 17000;
motorDriveUnit.powerMax_kW = 53;
motorDriveUnit.responseTime_s = 0.02;

motorDriveUnit.efficiency_pct = 98;
motorDriveUnit.spd_eff_rpm = 2000;
motorDriveUnit.trq_eff_Nm = 50;
motorDriveUnit.iron_loss_to_nominal_ratio = 0.1;
motorDriveUnit.elecLossConst_W = 30;

motorDriveUnit.rotorInertia_kg_m2 = 0.001;
motorDriveUnit.kDamp_Nm_per_radPerS = 0.005;
