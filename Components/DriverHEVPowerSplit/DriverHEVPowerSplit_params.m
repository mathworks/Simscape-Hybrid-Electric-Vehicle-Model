%% Parameters for Power-Split HEV Speed Tracking Driver
% Note that this script depends on some work space variables for plant
% which must be defined upfront elsewhere.

% Copyright 2021 The MathWorks, Inc.

%% Initial Conditions
% These are for controller/driver only.
% ICs for plant are defined elsewhere.

initial.driverHVBattSOC_pct = 85;

initial.driverBrakeForce_N = 8000;
initial.driverBrakeOn_tf = true;

%% Power-Split HEV Speed Tracking Driver

driver.tireRadius_m = vehicle.tireRollingRadius_m;

driver.brakeOnSpd_kph = 5;
driver.brakeOffSpdDiff_kph = 0.01; % must be On-Speed > Off-Speed
driver.brakeForceMax_N = 8000;
driver.brakeRate_N_per_s = 1000;

driver.hvbattCapacity_Ahr = batteryHighVoltage.capacity_Ahr;
driver.hvbattSocHighMid_pct = 90;
driver.hvbattSocMidLow_pct = 70;
driver.hvbattSocLowEmpty_pct = 6;

% MG2 Controller:
driver.mg2TrqMax_Nm = motorGenerator2.trqMax_Nm;
driver.mg2DecelSpdDiff_rpm = 0.5;
driver.mg2Ki = 15;
driver.mg2Kp = 15;

% MG1 Controller:
driver.mg1TrqMax_Nm = motorGenerator1.trqMax_Nm;
driver.mg1GenWeakTrqCmd_Nm = -10;
driver.mg1GenTrqCmd_Nm = -20;
driver.mg1StopEngTrqCmd_Nm = -10;
driver.mg1EngSpd_rpm = 0.1;

% Engine On Off logic for Engine and MG1 control:
driver.engOnVehSpd_kph = 50;  % Always use engine above this threshold
driver.chgSpd_kph = 70;  % Threshold vehicle speed to charge battery if driving while charge level not high

% Engine Controller:
driver.engTrqMax_Nm = engine.trqMax_Nm;
driver.engGenTrqCmd_Nm = 120;
driver.engKi = 15;
driver.engKp = 15;
