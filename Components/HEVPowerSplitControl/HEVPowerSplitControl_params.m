%% Parameters for Power-Split HEV Speed Tracking Driver
% Note that this script depends on some parameters for plant
% which must be defined upfront elsewhere.

% Copyright 2021 The MathWorks, Inc.

%% Power-Split HEV Speed Tracking Driver

hevcontrol.tireRadius_m = vehicle.tireRollingRadius_m;

hevcontrol.brakeOnSpd_kph = 5;
hevcontrol.brakeOffSpdDiff_kph = 0.01; % must be On-Speed > Off-Speed
hevcontrol.brakeForceMax_N = 8000;
hevcontrol.brakeRate_N_per_s = 1000;

hevcontrol.hvbattNominalCapacity_kWh = batteryHighVoltage.nominalCapacity_kWh;
hevcontrol.hvbattVoltagePerCell_V = batteryHighVoltage.voltagePerCell_V;
hevcontrol.hvbattSocHighMid_pct = 80;
hevcontrol.hvbattSocMidLow_pct = 30;
hevcontrol.hvbattSocLowEmpty_pct = 20;

% ## MG2 Controller
hevcontrol.mg2TrqMax_Nm = motorGenerator2.trqMax_Nm;
hevcontrol.mg2DecelSpdDiff_rpm = 0.5;
hevcontrol.mg2Ki = 15;
hevcontrol.mg2Kp = 15;

% ## MG1 Controller
hevcontrol.mg1TrqMax_Nm = motorGenerator1.trqMax_Nm;
hevcontrol.mg1GenLess_Nm = -8;
hevcontrol.mg1GenMore_Nm = -12;
hevcontrol.mg1StopEngTrqCmd_Nm = -10;
hevcontrol.mg1EngSpd_rpm = 0.1;

% ## Engine On Off logic for Engine and MG1 control

hevcontrol.mg1EngStartTrq_Nm = 20;
hevcontrol.mg1EngStartThreshold_rpm = 800;

% Always use engine above this threshold
hevcontrol.engOnVehSpd_kph = 50;

% Threshold vehicle speed to charge battery
% if driving while charge level not high
hevcontrol.chgSpd_kph = 60;

% ## Engine Controller
hevcontrol.engTrqMax_Nm = engine.trqMax_Nm;
hevcontrol.engGenTrqCmd_Nm = 120;
hevcontrol.engKi = 15;
hevcontrol.engKp = 15;

%% Initial Conditions
% These are for controller/driver only.
% ICs for plant are defined elsewhere.

initial.controllerHVBattSOC_pct = initial.highVoltageBatterySOC_pct;

initial.driverBrakeForce_N = 8000;
initial.driverBrakeOn_tf = true;
