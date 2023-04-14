%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

ComponentName = "PowerSplitHEV_DirectInput";

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "HEV", ComponentName);
assert(isfolder(TopFolder))

UnitTestFolder = fullfile(TopFolder, "test");
assert(isfolder(UnitTestFolder))

UnitTestFile = fullfile(UnitTestFolder, ComponentName+"_UnitTest.m");
assert(isfile(UnitTestFile))

TestCaseFolder = fullfile(TopFolder, "testcases");
assert(isfolder(TestCaseFolder))

UtilsFolder = fullfile(TopFolder, "utils");
assert(isfolder(UtilsFolder))

%%

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
  [ fullfile(TopFolder, "test", ComponentName+"_UnitTest.m"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_Constant.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_Downhill.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_Downhill_2.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_EngineDrive.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_MG1Drive.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_MG2Drive.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_MG2Drive_2.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_MG2Drive_StartEngine.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_MG2Drive_StartEngine_2.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_Parked_EngineChargeBattery.mlx"), ...
    fullfile(TopFolder, "testcases", "PowerSplitHEV_DI_testcase_PowerSplitDrive.mlx"), ...
    fullfile(TopFolder, "utils", "PowerSplitHEV_DirectInput_example.m"), ...
    fullfile(TopFolder, "utils", "PowerSplitHEV_DirectInput_InputSignalBuilder.m"), ...
    fullfile(TopFolder, "utils", "PowerSplitHEV_DirectInput_selectInput.m"), ...
    fullfile(TopFolder, "PowerSplitHEV_DirectInput_main_script.mlx") ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suite);

disp(results)
