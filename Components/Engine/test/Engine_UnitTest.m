classdef Engine_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName_simple = "Engine_harness_model";
  modelName_power_split = "Engine_harness_model_power_split";
end

methods (Test)

%% Test for Default Referenced Subsystem

function defaultReferencedSubsystem_1(testCase)
  close all
  bdclose all

  mdl = testCase.modelName_simple;
  load_system(mdl)
  refSubName = get_param(mdl+"/Engine", "ReferencedSubsystem");

  verifyEqual(testCase, refSubName, 'EngineCustom_refsub');
end

function defaultReferencedSubsystem_2(testCase)
  close all
  bdclose all

  mdl = testCase.modelName_power_split;
  load_system(mdl)
  refSubName =  get_param(mdl+"/Engine", "ReferencedSubsystem");

  verifyEqual(testCase, refSubName, 'EngineCustom_refsub');
end

%% Test Harness Model 1

function run_harnessSimple_1(testCase)
%% The most basic test - just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName_simple;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessSimple_2_1(testCase)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = testCase.modelName_simple;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineBasic_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessSimple_2_2(testCase)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = testCase.modelName_simple;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineCustom_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

%% Test for Harness Model 2

function run_harnessPowerSplit_1(testCase)
%% The most basic test - just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName_power_split;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessPowerSplit_2_1(testCase)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = testCase.modelName_power_split;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineBasic_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessPowerSplit_2_2(testCase)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = testCase.modelName_power_split;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineCustom_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

%% Test for Scripts

function plot_script_1(testCase)
%% Check that the plot script liked to the block works.

  close all
  bdclose all

  mdl = testCase.modelName_power_split;
  load_system(mdl)

  % Select subsystem
  set_param(0, "CurrentSystem", mdl+"/Engine")

  % Select block
  set_param(gcs, "CurrentBlock", "Engine")

  % A proper block must be selected for this script to work.
  % This is assuming that the default referenced subsystem for the "Engine" subsystem
  % contains the custom Engine block.
  EngineUtility.plotCustomEngineCurves(gcb);

  close all
  bdclose all
end  % function

function run_main_script_1(testCase)
%% Run script
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  Engine_main_script

  close all
  bdclose all
end  % function

end  % methods (Test)
end  % classdef
