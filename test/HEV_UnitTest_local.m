classdef HEV_UnitTest_local < matlab.unittest.TestCase
% This implements tests that should be run locally.

% Copyright 2021 The MathWorks, Inc.

methods (Test)

  function projectRunChecks(testCase)
  %% Programatically run the projects's Run Check.
  % This corresponds to "Project > Run Checks" in GUI.
  % This test checks that Run Checks ends with all clean.
    prj = currentProject;
    updateDependencies(prj);
    checkResults = runChecks(prj);
    resultTable = table(checkResults);  % *.Passed, *.ID, *.Description
    verifyEqual(testCase, all(resultTable.Passed==true), true);
  end

  function test_HevWorkflow(~)
  %% Run the HEV parameter sweep workflow script.
  % Note that individual figure windows will appear while this is running.
    evalin("base", "PowerSplitHEV_SpeedTracking_sweep");
  end

end  % methods (Test)
end  % classdef
