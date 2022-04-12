%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

ComponentName = "PowerSplitDriveUnit";

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "Components", ComponentName);
assert(isfolder(TopFolder))

% PackageFolder = fullfile(TopFolder, "+"+ComponentName+"Utility");
% assert(isfolder(PackageFolder))

HarnessFolder = fullfile(TopFolder, "harnessModels");
assert(isfolder(HarnessFolder))

UnitTestFolder = fullfile(TopFolder, "test");
assert(isfolder(UnitTestFolder))

TestCaseFolder = fullfile(TopFolder, "testcases");
assert(isfolder(TestCaseFolder))

UtilityFolder = fullfile(TopFolder, "utils");
assert(isfolder(UtilityFolder))

%% Test Suite & Runner

UnitTestFile = fullfile(UnitTestFolder, ComponentName+"_UnitTest.m");
assert(isfile(UnitTestFile))

suite = matlab.unittest.TestSuite.fromFile( UnitTestFile );

runner = matlab.unittest.TestRunner.withTextOutput( ...
            OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

% Test result file is created. There is no need to check its existance.
TestResultFile = "TestResults_" + RelStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
            fullfile(UnitTestFolder, TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

CoverageReportFolder = fullfile(TopFolder, "coverage" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

CoverageReportFile = RelStr + "_" + ComponentName + ".html";

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
                  CoverageReportFolder, ...
                  MainFile = CoverageReportFile );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
    fullfile(HarnessFolder, ComponentName+"_harness_setup.m"), ...
    fullfile(UnitTestFolder, ComponentName+"_UnitTest.m"), ...
    fullfile(TestCaseFolder, ComponentName+"Basic_testcase_basic.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"Basic_testcase_driveAxle.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"Basic_testcase_driveMg1.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"Basic_testcase_driveMg2.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"Basic_testcase_lockAxle_driveMg1.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"Basic_testcase_power_split.mlx"), ...
    fullfile(UtilityFolder, ComponentName+"_InputSignalBuilder.m"), ...
    fullfile(UtilityFolder, ComponentName+"_plot_hvbattery.m"), ...
    fullfile(UtilityFolder, ComponentName+"_plot_inputs.m"), ...
    fullfile(UtilityFolder, ComponentName+"_plot_psdu.m"), ...
    fullfile(UtilityFolder, ComponentName+"_plot_results.m"), ...
    fullfile(UtilityFolder, ComponentName+"_plot_vehicle.m"), ...
    fullfile(TopFolder, ComponentName+"_main_script.mlx") ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suite);

disp(results)
