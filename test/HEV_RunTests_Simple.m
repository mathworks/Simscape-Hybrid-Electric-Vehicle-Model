%% Script to run unit test and generate report

% Copyright 2021 The MathWorks, Inc.

%% Create test suite

import matlab.unittest.TestSuite;
s1 = TestSuite.fromMethod(?HEV_UnitTest, 'minimalTest_HevSpeedTracking_10s');
suite = s1;

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  'OutputDetail', matlab.unittest.Verbosity.Detailed);

%% Run tests

results = runner.run(suite);
assertSuccess(results);
