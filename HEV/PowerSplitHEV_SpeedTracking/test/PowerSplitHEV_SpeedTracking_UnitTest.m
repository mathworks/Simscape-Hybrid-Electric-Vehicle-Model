classdef PowerSplitHEV_SpeedTracking_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "PowerSplitHEV_system_model";
end

methods (Test)

function defaultReferencedSubsystems_1(testCase)
%% Test for Default Referenced Subsystems
% This ensures that all the subsystem reference blocks in the model file have
% intended referenced subsystems.
  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  refSubName = get_param(mdl+"/Controller & Environment", "ReferencedSubsystem");
  verifyEqual(testCase, refSubName, 'PowerSplitHEV_SpeedTracking_refsub');

  refSubName = get_param(mdl+"/High Voltage Battery", "ReferencedSubsystem");
  verifyEqual(testCase, refSubName, 'BatteryHVElec_refsub');

  refSubName = get_param(mdl+"/DC-DC Converter", "ReferencedSubsystem");
  verifyEqual(testCase, refSubName, 'DcDcConverterElec_refsub');

  refSubName = get_param(mdl+"/Power Split Drive Unit", "ReferencedSubsystem");
  verifyEqual(testCase, refSubName, 'PowerSplitDriveUnitBasic_refsub');

  refSubName = get_param(mdl+"/Longitudinal Vehicle", "ReferencedSubsystem");
  verifyEqual(testCase, refSubName, 'Vehicle1DCustom_refsub');

  close all
  bdclose all
end

function openAndRun_1(testCase)
%% Most basic check - open model and run simulation.
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

function openAndRun_2_1(testCase)
%% Check that the model runs without any warnings or errors.
% Specify the referenced subsystems.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/High Voltage Battery", ...
    "ReferencedSubsystem", "BatteryHVBasic_refsub")

  set_param(mdl+"/DC-DC Converter", ...
    "ReferencedSubsystem", "DcDcConverterBasic_refsub")

  set_param(mdl+"/Power Split Drive Unit/Engine", ...
    "ReferencedSubsystem", "EngineBasic_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));
  sim(simIn);

  close all
  bdclose all
end  % function

function openAndRun_2_2(testCase)
%% Check that the model runs without any warnings or errors.
% Specify the referenced subsystem.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/High Voltage Battery", ...
    "ReferencedSubsystem", "BatteryHVElec_refsub")

  set_param(mdl+"/DC-DC Converter", ...
    "ReferencedSubsystem", "DcDcConverterElec_refsub")

  set_param(mdl+"/Power Split Drive Unit/Engine", ...
    "ReferencedSubsystem", "EngineCustom_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));
  sim(simIn);

  close all
  bdclose all
end  % function

%%

function runLiveScript_basic(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % This is the most basic simulation where nothing interesting happens,
  % but this ensures that everything in the script works fine.
  evalin("base", "PowerSplitHEV_SpeedTracking_testcase_basic");

  close all
  bdclose all
end  % function

function runLiveScript_highSpeed(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  evalin("base", "PowerSplitHEV_SpeedTracking_testcase_highSpeed");

  close all
  bdclose all
end  % function

%% Live Scripts for drive pattern/cycle simulation

function runLiveScript_Accelerate_Decelerate(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  evalin("base", "PowerSplitHEV_SpeedTracking_Accelerate_Decelerate");

  close all
  bdclose all
end  % function

function runLiveScript_SimpleDrivePattern(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  evalin("base", "PowerSplitHEV_SpeedTracking_SimpleDrivePattern");

  close all
  bdclose all
end  % function

function runLiveScript_FTP75(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  evalin("base", "PowerSplitHEV_SpeedTracking_FTP75");

  close all
  bdclose all
end  % function

function runLiveScript_main_script(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  evalin("base", "PowerSplitHEV_SpeedTracking_main_script")

  close all
  bdclose all
end  % function

%% M scripts for drive pattern/cycle simulation

function runMScript_runsim_accel_decel(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % This sets up external inputs and override some parameters
  % then runs simulation.
  evalin("base", "PowerSplitHEV_SpeedTracking_runsim_accel_decel")

  close all
  bdclose all
end  % function

function runMScript_runsim_ftp75(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % This sets up external inputs and override some parameters
  % then runs simulation.
  evalin("base", "PowerSplitHEV_SpeedTracking_runsim_ftp75")

  close all
  bdclose all
end  % function

function runMScript_runsim_simple_pattern(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % This sets up external inputs and override some parameters
  % then runs simulation.
  evalin("base", "PowerSplitHEV_SpeedTracking_runsim_simple_pattern")

  close all
  bdclose all
end  % function

%% Live Scripts for application workflows

function runLiveScript_sweep(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  evalin("base", "PowerSplitHEV_SpeedTracking_sweep")

  close all
  bdclose all
end  % function

end  % methods (Test)
end  % classdef
