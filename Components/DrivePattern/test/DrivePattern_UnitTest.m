classdef DrivePattern_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "DrivePattern_harness_model";
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

%% Test for Inputs
% Check that the Input Signal Builder class works.

function input_Constant(~)
% All default
  close all
  builder = DrivePattern_InputSignalBuilder;
  data = Constant(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_Step3(~)
% Make a plot.
  close all
  builder = DrivePattern_InputSignalBuilder('Plot_tf',true);
  data = Step3(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_Step5(~)
% Make a plot.
  close all
  builder = DrivePattern_InputSignalBuilder('Plot_tf',true);
  data = Step5(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_Accelerate_Decelerate(~)
% Make a plot and save it as PNG file.
  close all
  builder = DrivePattern_InputSignalBuilder('Plot_tf',true);
  builder.VisiblePlot_tf = false;
  builder.SavePlot_tf = true;  % Save
  data = Accelerate_Decelerate(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
  assert(isfile("image_input_signals.png"))
  delete("image_input_signals.png")
end  % function

function input_Accelerate_Decelerate_Twice(~)
% Make a plot.
  close all
  builder = DrivePattern_InputSignalBuilder('Plot_tf',true);
  data = Accelerate_Decelerate_Twice(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_SimpleDrivePattern(~)
% Make a plot.
  close all
  builder = DrivePattern_InputSignalBuilder('Plot_tf',true);
  data = SimpleDrivePattern(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_FTP75(~)
% Make a plot.
  close all
  builder = DrivePattern_InputSignalBuilder('Plot_tf',true);
  data = FTP75(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

%% Test for Scripts
% Check that scripts run without any warnings or errors.

function run_testcase_1(~)
  close all
  bdclose all
  DrivePattern_testcase_Constant
  close all
  bdclose all
end

function run_testcase_2(~)
  close all
  bdclose all
  DrivePattern_testcase_Step3
  close all
  bdclose all
end

function run_testcase_3(~)
  close all
  bdclose all
  DrivePattern_testcase_Step5
  close all
  bdclose all
end

function run_testcase_4(~)
  close all
  bdclose all
  DrivePattern_testcase_AccelDecel
  close all
  bdclose all
end

function run_testcase_5(~)
  close all
  bdclose all
  DrivePattern_testcase_AccelDecelTwice
  close all
  bdclose all
end

function run_testcase_6(~)
  close all
  bdclose all
  DrivePattern_testcase_SimpleDrivePattern
  close all
  bdclose all
end

function run_testcase_7(~)
  close all
  bdclose all
  DrivePattern_testcase_FTP75
  close all
  bdclose all
end

function run_main_script_1(~)
  close all
  bdclose all
  DrivePattern_main_script
  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
