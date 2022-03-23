%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

ComponentName = "Vehicle1D";

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "Components", ComponentName);
assert(isfolder(TopFolder))

UnitTestFolder = fullfile(TopFolder, "test");
assert(isfolder(UnitTestFolder))

UnitTestFile = fullfile(UnitTestFolder, ComponentName+"_UnitTest.m");
assert(isfile(UnitTestFile))

suite = matlab.unittest.TestSuite.fromFile( UnitTestFile );

TestCaseFolder = fullfile(TopFolder, "testcases");
assert(isfolder(TestCaseFolder))

PackageFolder = fullfile(TopFolder, "+"+ComponentName+"Utility");
assert(isfolder(PackageFolder))

UtilsFolder = fullfile(TopFolder, "utils");
assert(isfolder(UtilsFolder))

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
  [ fullfile(UnitTestFolder, ComponentName+"_UnitTest.m"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_Brake3.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_Coastdown.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_Constant.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_DriveAxle.mlx"), ...
    fullfile(TestCaseFolder, ComponentName+"_testcase_RoadGrade3.mlx"), ...
    fullfile(PackageFolder, "getVehicle1DCustomBlockInfo.m"), ...
    fullfile(PackageFolder, "plotRoadLoad.m"), ...
    fullfile(PackageFolder, "reportVehicle1DCustomBlock.mlx"), ...
    fullfile(UtilsFolder, ComponentName+"_harness_setup.m"), ...
    fullfile(UtilsFolder, ComponentName+"_InputSignalBuilder.m"), ...
    fullfile(UtilsFolder, ComponentName+"_plot_results.m") ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suite);

disp(results)
