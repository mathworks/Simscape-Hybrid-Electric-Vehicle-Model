%% Parameters for Power-Split HEV Speed Tracking Driver

% Copyright 2021 The MathWorks, Inc.

%% Borrowed Parameters

% vehicle.tireRollingRadius_m = 0.3;
% batteryHighVoltage.capacity_Ahr = 30;
% motorGenerator2.trqMax_Nm = 163;  % P610
% motorGenerator1.trqMax_Nm = 40;  % P610
% engine.trqMax_Nm = 142;  % P610

%% Initial Conditions

initial.driverBrakeForce_N = 8000;
initial.driverBrakeOn_tf = true;
initial.driverHVBattSOC_pct = 95;

%% Power-Split HEV Speed Tracking Driver

driver.tireRadius_m = vehicle.tireRollingRadius_m;

driver.brakeOnSpd_kph = 5;
driver.brakeOffSpdDiff_kph = 0.01; % must be On-Speed > Off-Speed
driver.brakeForceMax_N = 8000;
driver.brakeRate_N_per_s = 1000;

driver.hvbattCapacity_Ahr = batteryHighVoltage.capacity_Ahr;
driver.hvbattSocHigh_pct = 90;
driver.hvbattSocLow_pct = 50;  % must be low < high

% MG2 Controller:
driver.mg2TrqMax_Nm = motorGenerator2.trqMax_Nm;
driver.mg2DecelSpdDiff_rpm = 0.5;  % 0.2 too small, 2 too large
% MG2's PI parameters, filter time constant

% MG1 Controller:
driver.mg1TrqMax_Nm = motorGenerator1.trqMax_Nm;
% MG1's PI parameters, filter time constant
driver.mg1GenTrqCmd_Nm = -20;
driver.mg1StopEngTrqCmd_Nm = -10;
driver.mg1EngSpd_rpm = 0.1;

% Engine On Off logic for Engine and MG1 control:
driver.engOnVehSpd_kph = 50;  % Always use engine above this threshold

% Engine Controller:
driver.engTrqMax_Nm = engine.trqMax_Nm;
% Engine's PI parameters, filter time constant
driver.engGenTrqCmd_Nm = 120;
