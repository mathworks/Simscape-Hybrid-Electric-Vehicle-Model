classdef Vehicle1D_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "Vehicle1D_harness_model";
end

methods (Test)

function blockParameters_Vehicle1DDriveline(testCase)
%% Check that block parameters are properly set up
% Vehicle1DDriveline_refsub is the default referenced subsystem.

  close all
  bdclose all

  mdl = "Vehicle1DDriveline_refsub";
  load_system(mdl)

  function verifyParameter(test_case, block_path, parameter_name, expected_variable, expected_unit)
    actual_entry = get_param(block_path, parameter_name);
    verifyEqual(test_case, actual_entry, expected_variable)

    actual_unit = get_param(block_path, parameter_name+"_unit");
    One_in_actual_unit = simscape.Value(1, actual_unit);
    value_in_expected_unit = value(One_in_actual_unit, expected_unit);
    verifyEqual(test_case, value_in_expected_unit, 1)
  end

  blkpath = mdl + "/Longitudinal Vehicle";

  actual = get_param(blkpath, 'vehParamType');
  verifyEqual(testCase, actual, 'sdl.enum.VehicleParameterizationType.RoadLoad')

  verifyParameter(testCase, blkpath, 'M_vehicle', 'vehicle.mass_kg', 'kg')

  verifyParameter(testCase, blkpath, 'R_tireroll', 'vehicle.tireRollingRadius_m', 'm')

  verifyParameter(testCase, blkpath, 'A_rl', 'vehicle.roadLoadA_N', 'N')

  verifyParameter(testCase, blkpath, 'B_rl', 'vehicle.roadLoadB_N_per_kph', 'N/(km/hr)')

  verifyParameter(testCase, blkpath, 'C_rl', 'vehicle.roadLoadC_N_per_kph2', 'N/(km/hr)^2')

  verifyParameter(testCase, blkpath, 'g', 'vehicle.roadLoad_gravAccel_m_per_s2', 'm/s^2')

  verifyParameter(testCase, blkpath, 'V_1', 'smoothing.vehicle_speed_threshold_kph', 'km/hr')

  verifyParameter(testCase, blkpath, 'w_1', 'smoothing.axle_speed_threshold_rpm', 'rpm')

  verifyParameter(testCase, blkpath, 'V_x', 'initial.vehicleSpeed_kph', 'km/hr')

end  % function

function blockParameters_Vehicle1DCustom(testCase)
%% Check that block parameters are properly set
% Vehicle1DCustom_refsub is an optional referenced subsystem.

  close all
  bdclose all

  mdl = "Vehicle1DCustom_refsub";
  load_system(mdl)

  function verifyParameter(test_case, block_path, parameter_name, expected_variable, expected_unit)
    actual_entry = get_param(block_path, parameter_name);
    verifyEqual(test_case, actual_entry, expected_variable)

    actual_unit = get_param(block_path, parameter_name+"_unit");
    One_in_actual_unit = simscape.Value(1, actual_unit);
    value_in_expected_unit = value(One_in_actual_unit, expected_unit);
    verifyEqual(test_case, value_in_expected_unit, 1)
  end

  blkpath = mdl + "/Longitudinal Vehicle";

  verifyParameter(testCase, blkpath, 'grav', 'vehicle.roadLoad_gravAccel_m_per_s2', 'm/s^2')

  verifyParameter(testCase, blkpath, 'M_e', 'vehicle.mass_kg', 'kg')

  verifyParameter(testCase, blkpath, 'R_tire', 'vehicle.tireRollingRadius_m', 'm')

  verifyParameter(testCase, blkpath, 'A_rl', 'vehicle.roadLoadA_N', 'N')

  verifyParameter(testCase, blkpath, 'B_rl', 'vehicle.roadLoadB_N_per_kph', 'N/(km/hr)')

  verifyParameter(testCase, blkpath, 'C_rl', 'vehicle.roadLoadC_N_per_kph2', 'N/(km/hr)^2')

  verifyParameter(testCase, blkpath, 'V_1', 'smoothing.vehicle_speed_threshold_kph', 'km/hr')

  verifyParameter(testCase, blkpath, 'w_1', 'smoothing.axle_speed_threshold_rpm', 'rpm')

  verifyParameter(testCase, blkpath, 'V_x', 'initial.vehicleSpeed_kph', 'km/hr')

end  % function

function run_harness_model_1(testCase)
%% The most basic test - just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function block_info_script_1(testCase)
%% Check that the block info script works.
% This check is only for Vehicle1DCustom_refsub.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Must set Vehicle1DCustom_refsub because it is not the default.
  set_param(mdl+"/Longitudinal Vehicle", ...
    "ReferencedSubsystem", "Vehicle1DCustom_refsub")

  % Select subsystem
  set_param(0, "CurrentSystem", mdl+"/Longitudinal Vehicle")

  % Select block
  set_param(gcs, "CurrentBlock", "Longitudinal Vehicle")

  % A proper block must be selected for this script to work.
  Vehicle1DUtility.reportVehicle1DCustomBlock

  close all
  bdclose all
end  % function

%% Test for Inputs
% Check that the Input Signal Builder class works.

function input_Constant(~)
% All default
  close all
  builder = Vehicle1D_InputSignalBuilder;
  data = Constant(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_Brake3(~)
% Make a plot.
  close all
  builder = Vehicle1D_InputSignalBuilder('Plot_tf',true);
  data = Brake3(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_RoadGrade3(~)
% Make a plot.
  close all
  builder = Vehicle1D_InputSignalBuilder('Plot_tf',true);
  data = RoadGrade3(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_DriveAxle(~)
% Make a plot and save it as PNG file.
  close all
  builder = Vehicle1D_InputSignalBuilder('Plot_tf',true);
  builder.VisiblePlot_tf = false;
  builder.SavePlot_tf = true;  % Save
  data = DriveAxle(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
  assert(isfile("image_input_signals.png"))
  delete("image_input_signals.png")
end  % function

%% Test for Scripts
% Check that scripts run without any warnings or errors.

function run_report_script_1(~)
  close all
  bdclose all

  % Vehicle1DDriveline is the default.
  % This generates a PNG file.
  Vehicle1DDriveline_reportBlockProperty

  close all
  bdclose all
end

function run_report_script_2(~)
  close all
  bdclose all

  % Vehicle1DCustom is optional.
  % This generates a PNG file.
  Vehicle1DCustom_reportBlockProperty

  close all
  bdclose all
end

function run_testcase_1(~)
  close all
  bdclose all
  Vehicle1D_testcase_Constant
  close all
  bdclose all
end

function run_testcase_2(~)
  close all
  bdclose all
  Vehicle1D_testcase_Coastdown
  close all
  bdclose all
end

function run_testcase_3(~)
  close all
  bdclose all
  Vehicle1D_testcase_RoadGrade3
  close all
  bdclose all
end

function run_testcase_4(~)
  close all
  bdclose all
  Vehicle1D_testcase_Brake3
  close all
  bdclose all
end

function run_testcase_5(~)
  close all
  bdclose all
  Vehicle1D_testcase_DriveAxle
  close all
  bdclose all
end

function run_main_script_1(~)
  close all
  bdclose all
  Vehicle1D_main_script
  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
