classdef PowerSplitDriveUnit_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2022 The MathWorks, Inc.

properties (Constant)
  modelName = "PowerSplitDriveUnit_harness_model"
end

methods (Test)

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

function run_harness_model_2_1(testCase)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Power Split Drive Unit/Engine", "ReferencedSubsystem", "EngineBasic_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harness_model_2_2(testCase)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Power Split Drive Unit/Engine", "ReferencedSubsystem", "EngineCustom_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

%% Test for Scripts

function run_main_script_1(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  PowerSplitDriveUnit_main_script

  close all
  bdclose all
end  % function

function run_script_1(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  PowerSplitDriveUnitBasic_testcase_basic

  close all
  bdclose all
end  % function

function run_script_2(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  PowerSplitDriveUnitBasic_testcase_driveAxle

  close all
  bdclose all
end  % function

function run_script_3(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  PowerSplitDriveUnitBasic_testcase_driveMg2

  close all
  bdclose all
end  % function

function run_script_4(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  PowerSplitDriveUnitBasic_testcase_driveMg1

  close all
  bdclose all
end  % function

function run_script_5(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  PowerSplitDriveUnitBasic_testcase_lockAxle_driveMg1

  close all
  bdclose all
end  % function

function run_script_6(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  PowerSplitDriveUnitBasic_testcase_power_split

  close all
  bdclose all
end  % function

end  % methods (Test)
end  % classdef
