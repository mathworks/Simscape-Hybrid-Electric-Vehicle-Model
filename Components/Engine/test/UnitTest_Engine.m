classdef UnitTest_Engine < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

methods (Test)

function run_harnessSimple_1(~)
%% The most basic test - just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = "harnessSimple_Engine";

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessSimple_2_1(~)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = "harnessSimple_Engine";

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineBasic_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessSimple_2_2(~)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = "harnessSimple_Engine";

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineCustom_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

%%

function run_harnessPowerSplit_1(~)
%% The most basic test - just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = "harnessPowerSplit_Engine";

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessPowerSplit_2_1(~)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = "harnessPowerSplit_Engine";

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineBasic_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harnessPowerSplit_2_2(~)
%% Set the referenced subsystem and run simulation.

  close all
  bdclose all

  mdl = "harnessPowerSplit_Engine";

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  set_param(mdl+"/Engine", "ReferencedSubsystem", "EngineCustom_refsub")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

end  % methods (Test)
end  % classdef
