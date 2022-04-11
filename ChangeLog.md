# Change Log

## Version 1.3 (2022)

MATLAB Release

- This version requires MATLAB R2022a or newer.

Project

- Simulink model files are saved in `mdl` format.

Models

- Longitudinal Vehicle block from Simscape Driveline is
  added as a new (and default) Referenced Subsystem.
  The previous custom block is still included too.

## Version 1.2 (2022)

MATLAB Release

- This version requires MATLAB R2021a ore newer.

Highlights

- **MATLAB Unit Test** files are added for some models and scripts.
  More will be added in the coming updates.
- **GitHub Actions** continuous integration is used to automatically
  run unit tests when the repository in GitHub gets updated.
  - Set-up file: `.github/workflow/ci.yml`
  - For more general information about using GitHub Actions with MATLAB,
    see [MATLAB Actions](https://github.com/matlab-actions/overview).

Models

- Power-Split HEV system model is refactored to clean up.
  Previously two separate system models existed
  for speed tracking simulation and direct torque input simulation.
  They are now merged into one.
- Battery block from Simscape Electrical is added as
  a new referenced subsystem for High-Voltage Battery component.
  The previous model is included as well.
- DC-DC Converter block from Simscape Electrical is added as
  a new referenced subsystem for DC-DC Converter component.
  The previous model is included as well.
- Custom Engine block is added as a new referenced subsystem
  for Engine component.
  The previous model is included as well.
  The custom block is parameterized with peak torque,
  engine speed at peak torque, and peak power.
  The block parameter window provides a link to
  make the plots of engine torque and power curves.
- MG2, MG1, and Engine components have
  a torsional Spring-Damper block from Simscape Driveline
  or equivalent blocks from Foundation Library.
  This allows the energy to properly dissipate when necessary,
  thereby improving simulation robustness and performance.
- MG1 controller can start the engine.
  This better models the power-split HEV controller.
- Scopes are moved to individual components.
  This cleans up models, streamlines development workflow,
  and makes model navigation easier.

Test

- Project top-level unit test is added.
  See files under `test`.
  - `HEVProject_runtests.m` automatically finds all unit test files
    in the project folder tree and runs them.
    `.github/workflow/ci.yml` for GitHub Actions uses this
    to perform unit test when the repository is pushed to GitHub.
- Power-Split HEV system model has unit test files in
  - `HEV` > `PowerSplitHEV_DirectInput` > `test`
  - `HEV` > `PowerSplitHEV_SpeedTracking` > `test`
  - Unit test files:
    - `PowerSplitHEV_DirectInput_UnitTest.m`
    - `PowerSplitHEV_SpeedTracking_UnitTest.m`
  - Test runners:
    - `PowerSplitHEV_DirectInput_runtests.m`
    - `PowerSplitHEV_SpeedTracking_runtests.m`
    - Running these scripts perform unit test and produce
      MATLAB code coverage report.
- Vehicle1D component has unit test files in
  - `Components` > `Vehicle1D` > `test`
- Power-Split Drive Unit component has unit test files in
  - `Components` > `PowerSplitDriveUnit` > `test`
- Engine component has unit test files in
  - `Components` > `Engine` > `test`
- Drive Pattern component has unit test files in
  - `Components` > `DrivePattern` > `test`

Other updates

- Refactored many folders, models, and scripts.

## Version 1.1 (2021)

MATLAB Release

- MATLAB R2021a or newer release is required.

Highlights

- Parameter Sweep Workflow in Live Script
  - Demonstrates how to investigate the effect of reduction gear ratio,
    high-voltage battery capacity and high-voltage battery weight
    on the electrical efficiency.
    You can optionally use Parallel Computing Toolbox to shorten
    total simulation time.
  - Watch [YouTube video](https://www.youtube.com/watch?v=cbo83A8K_4w)
    showing the workflow as well as real-time application.
    - Real-Time application presented in the video will be added
      to this project in future updates.
