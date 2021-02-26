%% Setup Script for Power-Split HEV with Speed Tracking

% Copyright 2021 The MathWorks, Inc.

%% Input Signals

% Vehicle longitudinal velocity reference
[inputSignals_DrivingPattern, inputBus_DrivingPattern, t_end_1, useKph, useFromWorkspace] = ...
  DrivingPatternBasic_inputs("InputPattern", "accelerate_decelerate_kph");
%   DrivingPatternBasic_inputs("InputPattern", "simple_drive_pattern");
%   DrivingPatternBasic_inputs("InputPattern", "ftp75_mph");

% Road grade
[inputSignals_RoadGrade, inputBus_RoadGrade, t_end_2] = ...
  DriverAndEnvironment_road_grade_pattern("InputPattern", "all_zero");

% Simulation time
t_end = max(t_end_1, t_end_2);
clear t_end_1 t_end_2

%% Parameters in Driver & Environment / Driving Pattern

drivingPattern.useFromWorkspace_tf = useFromWorkspace;
clear useFromWorkspace

%% Other Parameters

PowerSplitHEV_params

DriverHEVPowerSplit_params  % load this last
