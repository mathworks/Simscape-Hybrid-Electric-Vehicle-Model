classdef Vehicle1D_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "Vehicle1D_harness_model";
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

function block_info_script_1(testCase)
%% Check that the block info script works.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

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
