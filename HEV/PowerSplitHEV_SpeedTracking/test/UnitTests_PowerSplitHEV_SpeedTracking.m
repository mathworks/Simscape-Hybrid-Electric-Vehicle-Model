classdef UnitTests_PowerSplitHEV_SpeedTracking < matlab.unittest.TestCase
% Class implementation of unit tests

% Copyright 2021-2022 The MathWorks, Inc.

methods (Test)

function runSpeedTrackingSim_10s(~)
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = "PowerSplitHEV_SpeedTracking";

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)
  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));
  sim(simIn);

  close all
  bdclose all
end  % function

function runLiveScript_1(~)
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % "All Zero" simulation is the most basic simulation
  % where nothing interesting happens,
  % but this ensures that everything in the script works fine.
  evalin("base", "PowerSplitHEV_SpeedTracking_all_zero");

  close all
  bdclose all
end  % function

function runAccelDecelSim(~)
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % This sets up external inputs and override some parameters
  % then runs simulation.
  PowerSplitHEV_SpeedTracking_runsim_accel_decel

  close all
  bdclose all
end  % function

function runSimpleDrivePatternSim(~)
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % This sets up external inputs and override some parameters
  % then runs simulation.
  PowerSplitHEV_SpeedTracking_runsim_simple_pattern

  close all
  bdclose all
end  % function

function runFTP75Sim(~)
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  % This sets up external inputs and override some parameters
  % then runs simulation.
  PowerSplitHEV_SpeedTracking_runsim_ftp75

  close all
  bdclose all
end  % function

function runHEVParameterSweepWorkflow(~)
% Check that the script runs without any warnings or errors.

  close all
  bdclose all

  evalin("base", "PowerSplitHEV_SpeedTracking_sweep");

  close all
  bdclose all
end  % function

end  % methods (Test)
end  % classdef
