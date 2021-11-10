classdef HEV_UnitTest < matlab.unittest.TestCase
% This implements unit tests that should be run both locally and in CI.

% Copyright 2021 The MathWorks, Inc.

methods (Test)

  function testMATLABVersion_21a(testCase)
    expected = "R2021a";
    actual = matlabRelease.Release;
    verifyEqual(testCase, actual, expected);
  end

  function minimalTest_HevSpeedTracking_10s(testCase)
    mdl = "PowerSplitHEV_SpeedTracking";
    t_end = 10;  % Simulation stop time in seconds
    if not(bdIsLoaded(mdl)), load_system(mdl); end
    in = Simulink.SimulationInput(mdl);
    in = setModelParameter(in, 'StopTime',num2str(t_end));
    sim(in);
    bdclose(mdl)
  end

end  % methods (Test)
end  % classdef
