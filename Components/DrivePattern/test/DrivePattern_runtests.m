%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

ComponentName = "DrivePattern";

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

UtilsFolder = fullfile(TopFolder, "utils");
assert(isfolder(UtilsFolder))

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
    fullfile(TestCaseFolder, ComponentName+"_testcase_AccelDecel.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_AccelDecelTwice.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_Constant.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_FTP75.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_SimpleDrivePattern.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_Step3.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_Step5.mlx"), ...
    fullfile(UtilsFolder, ComponentName+"_InputSignalBuilder.m"), ...
    fullfile(UtilsFolder, ComponentName+"_plot_inputs.m"), ...
    fullfile(UtilsFolder, ComponentName+"_plot_results.m"), ...
    fullfile(TopFolder, ComponentName+"_main_script.mlx") ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suite);

disp(results)
