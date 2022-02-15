classdef UnitTests_PowerSplitHEV_SpeedTracking < matlab.unittest.TestCase
% Class implementation of unit tests

% Copyright 2021-2022 The MathWorks, Inc.

methods (Test)

  function test_SpeedTracking_run_10s(~)
  %% Check that the model runs without any warnings or errors.

    mdl = "PowerSplitHEV_SpeedTracking";
    bdclose(mdl)

    t_end = 10;  % Simulation stop time in seconds

    load_system(mdl)
    in = Simulink.SimulationInput(mdl);
    in = setModelParameter(in, 'StopTime',num2str(t_end));
    sim(in);

    bdclose(mdl)

  end

  function test_ParameterSweepWorkflow(~)
  %% Run the HEV parameter sweep workflow script.
  % Note that individual figure windows will appear while this is running.

    evalin("base", "PowerSplitHEV_SpeedTracking_sweep");

  end

end  % methods (Test)
end  % classdef
