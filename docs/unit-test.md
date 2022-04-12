---
---
# Unit Test

MATLAB unit test framework is used to run tests,
collect pass/fail results, and generate result reports.

In this project, unit tests are built for individual components
and system-level models separately
so that unit test for a component or a system can be done
in an isolated manner.
There is also a project-level unit test
which automatically finds component-level and system-level
unit tests and runs them all in one go.

The result of unit tests is stored in two ways.
One is _a test summary in XML_.
The other is _a MATLAB code coverage report in HTML_.
Test summary includes the list of tests,
the number of failures, time for each test, and so on.
Code coverage report includes
the number of executed lines,
the number of executable lines,
the ratio of these numbers,
and much more information for tested `.m` and `.mlx` files.

Note that coverage reports are not included in the repository
to avoid overwhelming the repository.
You can generate them in your machine by running tests locally.

## Component-Level Test

Some of the components have unit test files under the `test` folder.
For example, the Vehicle1D component's test folder is
[/Components/Vehicle1D/test][url-veh1d-test].

[url-veh1d-test]:https://github.com/mathworks/Simscape-Hybrid-Electric-Vehicle-Model/tree/main/Components/Vehicle1D/test

Unit tests are implemented in `<component>_UnitTest.m` file,
such as `Vehicle1D_UnitTest.m`.

Test runner script `<component>_runtests.m`
such as `Vehicle1D_runtests.m` runs unit tests.
While running tests, the runner reports the test progress.
When test ends, the runner generates a test summary
and a MATLAB code coverage report.
Test summary and coverage report are generated
by plug-ins for the test runner.
See the runner script for how to use the plug-ins.

## System-Level Test

Similar to component-level test,
system-level test files are stored in the `test` folder.
For example, the system-level test folder for
the power-split HEV direct torque input is
[/HEV/PowerSplitHEV_DirectInput/test][url-direct-test].

[url-direct-test]:https://github.com/mathworks/Simscape-Hybrid-Electric-Vehicle-Model/tree/main/HEV/PowerSplitHEV_DirectInput/test

## Project-Level Test

There is a project-level test runner script
`<project_name>_runtests.m`
in the top [/test][url-prj-test] folder of the project.
This script finds all the unit test implementation files
in the project folder and runs all of them.
Note that running this script may take long time to finish.

[url-prj-test]:https://github.com/mathworks/Simscape-Hybrid-Electric-Vehicle-Model/tree/main/test

## MATLAB and Continuous Integration in GitHub

The repository of this project in GitHub uses GitHub Actions CI
to automatically run tests when the repository is pushed.
There is no set up required to use GitHub Actions
as long as the repository is public in GitHub.
MATLAB (R2020a or later) is also freely available
as [MATLAB Actions](https://github.com/matlab-actions/overview)
for use in GitHub Actions.

GitHub Actions is configured in
the [.github/workflow/ci.yml][url-ci-yml] file
which runs the proejct-level test runner script.

[url-ci-yml]:https://github.com/mathworks/Simscape-Hybrid-Electric-Vehicle-Model/blob/main/.github/workflows/ci.yml

_Copyright 2022 The MathWorks, Inc._
