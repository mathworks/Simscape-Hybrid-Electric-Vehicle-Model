%% Test harness set-up script

% Copyright 2022 The MathWorks, Inc.

%% Load default parameter values

% Use the vehicle system-level set up as default values.
PowerSplitHEV_params

%% Model and Block Parameters

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

testharness.reducerGearRatio_1 = 1;
testharness.geartrainFriction_Nm_per_rpm = 0.001;
testharness.tireRollingRadius_m = 0.3;
testharness.vehicleMass_kg = 1700;

% Initial values

initial.engine_torque_Nm = 0;
% initial.EngineTorqueCommand_Nm = 0;
initial.engine_speed_rpm = 1000;

%% External inputs

engineInputBuilder = InputSignalBuilder_Engine;

engineInputData = Input_Constant(engineInputBuilder);
engineTestInput_Signals = engineInputData.Signals;
engineTestInput_Bus = engineInputData.Bus;
