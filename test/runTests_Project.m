%% Script to run unit tests

% Copyright 2021-2022 The MathWorks, Inc.

relstr = matlabRelease().Release;
disp("This MATLAB Release: " + relstr)

%% Create test suite

prjroot = currentProject().RootFolder;

suite = matlab.unittest.TestSuite.fromFolder(prjroot, "IncludingSubfolders",true);

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
          "OutputDetail", matlab.unittest.Verbosity.Detailed);

%% JUnit style test result

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
          "TestResults_" + relstr + ".xml");

addPlugin(runner, plugin)

%% Run tests

results = run(runner, suite);

disp(results)
