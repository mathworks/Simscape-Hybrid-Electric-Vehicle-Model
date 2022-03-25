classdef PowerSplitHEV_DirectInput_UnitTest < matlab.unittest.TestCase
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
  verifyEqual(testCase, refSubName, 'PowerSplitHEV_DirectInput_refsub');

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

%% Test for Scripts
% Check that scripts run without any warnings or errors.

function runLiveScript_DirectInput_Constant(~)
  close all
  bdclose all

  % The "Constant" simulation is the most basic simulation
  % where nothing interesting happens,
  % but this ensures that everything in the script works fine.
  PowerSplitHEV_DI_testcase_Constant

  close all
  bdclose all
end

function runLiveScript_DirectInput_Accel(~)
  close all
  bdclose all
  PowerSplitHEV_DI_testcase_Accel
  close all
  bdclose all
end

function runLiveScript_DirectInput_Downhill(~)
  close all
  bdclose all
  PowerSplitHEV_DI_testcase_Downhill
  close all
  bdclose all
end

function runLiveScript_DirectInput_Downhill_2(~)
  close all
  bdclose all
  PowerSplitHEV_DI_testcase_Downhill_2
  close all
  bdclose all
end

function runLiveScript_DirectInput_MG1Drive(~)
  close all
  bdclose all
  PowerSplitHEV_DI_testcase_MG1Drive
  close all
  bdclose all
end

function runLiveScript_DirectInput_MG2Drive(~)
  close all
  bdclose all
  PowerSplitHEV_DI_testcase_MG2Drive
  close all
  bdclose all
end

function runLiveScript_DirectInput_MG2Drive_2(~)
  close all
  bdclose all
  PowerSplitHEV_DI_testcase_MG2Drive_2
  close all
  bdclose all
end

function runLiveScript_DirectInput_PowerSplitDrive(~)
  close all
  bdclose all
  PowerSplitHEV_DI_testcase_PowerSplitDrive
  close all
  bdclose all
end

%{
function runLiveScript_main_script(~)
  close all
  bdclose all
  PowerSplitHEV_DirectInput_main_script
  close all
  bdclose all
end
%}

end  % methods (Test)
end  % classdef
