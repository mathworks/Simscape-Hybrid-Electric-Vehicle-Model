classdef PowerSplitHEV_SpeedTracking_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "PowerSplitHEV_system_model";
end

methods (TestClassSetup)
%% Functions to be executed when this unit test class is instanciated.

function setReferencedSubsystems(testCase)
%% Set referenced subsystems for this unit test.
% Note that other referenced subsystems may also be used in some tests.

  disp("Running a function from TestClassSetup...")

  % Teardown sets a function to be executed when the class object is destroyed.
  % In this case, recover the "global default" referenced subsystems.
  addTeardown(testCase, @PowerSplitHEV_resetReferencedSubsystems, testCase.modelName)

  mdl = testCase.modelName;
  load_system(mdl)

  set_param( mdl + "/Controller & Environment", ...
    ReferencedSubsystem = "PowerSplitHEV_SpeedTracking_refsub");

  set_param( mdl + "/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHV_refsub_Basic");

  set_param( mdl + "/DC-DC Converter", ...
    ReferencedSubsystem = "DcDcConverterElec_refsub");

  set_param( mdl + "/Power Split Drive Unit", ...
    ReferencedSubsystem = "PowerSplitDriveUnitBasic_refsub");

  set_param( mdl + "/Longitudinal Vehicle", ...
    ReferencedSubsystem = "Vehicle1D_refsub_Driveline");

  save_system(mdl)

end  % function

end  % methods (TestClassSetup)

methods (Test)

function openAndRun_1(testCase)
%% Most basic check - open model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime=num2str(t_end));
  sim(simIn);

  close all
  bdclose all
end  % function

function openAndRun_2_1(testCase)
%% Check that the model runs without any warnings or errors.
% Test referenced subsystems that are different from this unit test's default.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHV_refsub_Basic")

  set_param(mdl+"/DC-DC Converter", ...
    ReferencedSubsystem = "DcDcConverterBasic_refsub")

  set_param(mdl+"/Power Split Drive Unit/Engine", ...
    ReferencedSubsystem = "EngineBasic_refsub")

  set_param(mdl+"/Longitudinal Vehicle", ...
    ReferencedSubsystem = "Vehicle1D_refsub_Custom")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime=num2str(t_end));
  sim(simIn);

  close all
  bdclose all
end  % function

function openAndRun_2_2(testCase)
%% Check that the model runs without any warnings or errors.
% Test referenced subsystems that are different from this unit test's default.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHV_refsub_Electrical")

  set_param(mdl+"/DC-DC Converter", ...
    ReferencedSubsystem = "DcDcConverterElec_refsub")

  set_param(mdl+"/Power Split Drive Unit/Engine", ...
    ReferencedSubsystem = "EngineCustom_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime=num2str(t_end));
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
  PowerSplitHEV_SpeedTracking_testcase_basic

  close all
  bdclose all
end  % function

function runLiveScript_highSpeed(~)
%% Check that the script runs without any warnings or errors.
  close all
  bdclose all
  PowerSplitHEV_SpeedTracking_testcase_highSpeed
  close all
  bdclose all
end  % function

%% Live Scripts for drive pattern/cycle simulation

function runLiveScript_Accelerate_Decelerate(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % If script loads some variables to the base workspace
  % (for example by calling a function which explicitly does so with assignin),
  % the script must be explicitly evaluated in the base workspace.
  evalin("base", "PowerSplitHEV_SpeedTracking_Accelerate_Decelerate")

  close all
  bdclose all
end  % function

function runLiveScript_SimpleDrivePattern(~)
%% Check that the script runs without any warnings or errors.
  close all
  bdclose all

  % If script loads some variables to the base workspace
  % (for example by calling a function which explicitly does so with assignin),
  % the script must be explicitly evaluated in the base workspace.
  evalin("base", "PowerSplitHEV_SpeedTracking_SimpleDrivePattern")

  close all
  bdclose all
end  % function

function runLiveScript_FTP75(~)
%% Check that the script runs without any warnings or errors.
  close all
  bdclose all

  % If script loads some variables to the base workspace
  % (for example by calling a function which explicitly does so with assignin),
  % the script must be explicitly evaluated in the base workspace.
  evalin("base", "PowerSplitHEV_SpeedTracking_FTP75")

  close all
  bdclose all
end  % function

function runLiveScript_main_script(~)
%% Check that the script runs without any warnings or errors.
  close all
  bdclose all

  % Delete the png files of simulation result plots.
  imgFolder = fullfile( ...
    currentProject().RootFolder, "HEV", "PowerSplitHEV_SpeedTracking", "images");
  delete(fullfile(imgFolder, "*.png"))

  % If script loads some variables to the base workspace
  % (for example by calling a function which explicitly does so with assignin),
  % the script must be explicitly evaluated in the base workspace.

  % First run creates png files.
  evalin("base", "PowerSplitHEV_SpeedTracking_main_script")

  % Second run uses existing png files.
  % This is to improve code coverage.
  evalin("base", "PowerSplitHEV_SpeedTracking_main_script")

  close all
  bdclose all
end  % function

%% Live Scripts for application workflows

function runLiveScript_sweep(~)
%% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % If script loads some variables to the base workspace
  % (for example by calling a function which explicitly does so with assignin),
  % the script must be explicitly evaluated in the base workspace.
  evalin("base", "PowerSplitHEV_SpeedTracking_sweep")

  close all
  bdclose all
end  % function

end  % methods (Test)
end  % classdef
