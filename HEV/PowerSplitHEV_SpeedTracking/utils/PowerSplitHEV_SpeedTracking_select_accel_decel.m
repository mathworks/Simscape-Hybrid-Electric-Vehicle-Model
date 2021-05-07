%% Select Input Pattern for Power-Split HEV with Speed Tracking

% Copyright 2021 The MathWorks, Inc.

mdl = "PowerSplitHEV_SpeedTracking";
if not(bdIsLoaded(mdl)), open_system(mdl); end

input_pattern = "accelerate_decelerate_kph";
disp("Selecting " + input_pattern + " (input_pattern workspace variable)")

% Longitudinal vehicle speed reference
[inputSignals_DrivingPattern, inputBus_DrivingPattern, initial_DrvPtn, opt1] = ...
  DrivingPatternBasic_inputs("InputPattern", input_pattern);

drivingPattern.useFromWorkspace_tf = opt1.useFromWorkspace;

% Road slope
[inputSignals_RoadGrade, inputBus_RoadGrade, opt2] = ...
  DriverAndEnvironment_road_grade_pattern("InputPattern", "flat");

% Simulation time
t_end = max(opt1.t_end, opt2.t_end);

dt = 0;  % 0 for variable-step solver
