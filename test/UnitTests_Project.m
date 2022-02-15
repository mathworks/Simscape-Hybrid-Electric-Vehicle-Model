classdef UnitTests_Project < matlab.unittest.TestCase
% Class implementation of unit tests

% Copyright 2021-2022 The MathWorks, Inc.

methods (Test)

  function projectRunChecks(testCase)
  %% Programatically run MATLAB Projects's Run Checks.
  % This corresponds to "Project > Run Checks" in GUI.
  % This test checks that Run Checks ends without any issues.
  % Note that this does not help you fix issues.
  % When this test fails, you must fix manually.
    prj = currentProject;
    updateDependencies(prj);
    checkResults = runChecks(prj);
    resultTable = table(checkResults);  % *.Passed, *.ID, *.Description
    verifyEqual(testCase, all(resultTable.Passed==true), true);
  end

end  % methods (Test)
end  % classdef
