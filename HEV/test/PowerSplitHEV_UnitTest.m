classdef PowerSplitHEV_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2022 The MathWorks, Inc.

properties (Constant)
  modelName = "PowerSplitHEV_system_model";
end

methods (Test)

function run_system_model_1(testCase)
%% The most basic test - just open the model and run simulation.
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

%% Test for Scripts
% Check that scripts run without any warnings or errors.

function run_report_script_1(~)
  close all
  bdclose all

  % This generates PNG files.
  PowerSplitHEV_reportBlockProperty

  close all
  bdclose all
end

function run_main_script_1(~)
  close all
  bdclose all
  PowerSplitHEV_main_script
  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
