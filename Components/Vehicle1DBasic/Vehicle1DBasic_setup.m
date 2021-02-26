%% Setup Script for Simple 1D Vehicle

% Copyright 2020-2021 The MathWorks, Inc.

%% Input signals

[inputSignals_Vehicle1D, inputBus_Vehicle1D, t_end] = ...
  Vehicle1DBasic_inputs("InputPattern", "acceleration");

%% Initial conditions

initial.vehicleSpeed_kph = 0;
initial.GeartrainSpeed_rpm = 0;

%% Block parameters

vehicle.mass_kg = 1790;  % 1790kg for 2016 Toyota Prius (XW50, P610)
vehicle.tireRollingRadius_m = 0.3;
vehicle.roadLoadA_N = 175;
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.032;
vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

gearTrain.friction_Nm_per_rpm = 0.01;

gearTrain.inertia_kg_m2 = 161.1;  % 1790*0.3^2==161.1
% r = 0.3 m --> r^2 = 0.09 m^2
% M = 1200 kg --> M*r^2 = 108 kg*m^2
% M = 1600 kg --> M*r^2 = 144 kg*m^2
% M = 2000 kg --> M*r^2 = 180 kg*m^2
