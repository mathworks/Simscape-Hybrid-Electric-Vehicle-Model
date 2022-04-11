%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

ComponentName = "PowerSplitHEV";

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "HEV");
assert(isfolder(TopFolder))

UnitTestFolder = fullfile(TopFolder, "test");
assert(isfolder(UnitTestFolder))

UnitTestFile = fullfile(UnitTestFolder, ComponentName+"_UnitTest.m");
assert(isfile(UnitTestFile))

suite = matlab.unittest.TestSuite.fromFile( UnitTestFile );

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
    fullfile(UtilsFolder, ComponentName+"_openSpeedTracking.m"), ...
    fullfile(UtilsFolder, ComponentName+"_plot_result_compact.m"), ...
    fullfile(UtilsFolder, ComponentName+"_plot_result_hvbattery.m"), ...
    fullfile(UtilsFolder, ComponentName+"_plot_result_powersplit.m"), ...
    fullfile(UtilsFolder, ComponentName+"_plot_result_vehicle.m"), ...
    fullfile(UtilsFolder, ComponentName+"_report.mlx"), ...
    fullfile(UtilsFolder, ComponentName+"_resetReferencedSubsystems.m"), ...
    fullfile(UtilsFolder, ComponentName+"_system_model_setup.m"), ...
    fullfile(TopFolder, ComponentName+"_main_script.mlx"), ...
    fullfile(TopFolder, ComponentName+"_params.m")], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suite);

disp(results)
