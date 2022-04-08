# Hybrid Electric Vehicle Model in Simscape&trade;

[![View Hybrid Electric Vehicle Model in Simscape on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/92820-hybrid-electric-vehicle-model-in-simscape)

Version 1.3.alpha

## Introduction

This example includes a Hybrid Electric Vehicle model
in Simscape&trade;,
demonstrating some new features of the recent releases
of MATLAB&reg;
and featuring Subsystem Reference which enables
modular physical modeling workflow.

The model includes
an abstract Power-Split Hybrid Electric Vehicle (HEV) model
with a simple rule-based controller
for speed tracking simulation.
It can be used to better understand
how to work with [Subsystem Reference][url_subref]
for an automotive application.
For a vehicle model that includes
more detailed supervisory and engine controllers,
please see the reference applications in
[Powertrain Blockset&trade;][url_ptbsref].

[url_subref]:https://www.mathworks.com/help/simulink/ug/referenced-subsystem-1.html

[url_ptbsref]:https://www.mathworks.com/help/autoblks/powertrain-reference-applications.html

The included abstract model is suitable
for the system level simulation of
longitudinal vehicle behavior
as it runs faster than real time.
The model consists of components such as motor, engine,
power-split device, and so on,
and they are built in a modular manner using
Subsystem Reference and Simscape product family
demonstrating a workflow where
physical components are built and tested individually
and also they can be easily integrated into
a complete vehicle system model.

The HEV model and its component files are managed
by a MATLAB project and
some components come with their own test setups.

![Model Screenshot](utils/image_PowerSplitHEV_system_model.png)

![Plot of Simulation Result](utils/image_simulation_results_ftp75.png)

## For MATLAB R2022a

Power-Split HEV version 1.3 is currently under development
and *may be broken*. :)

- Required:
  [MATLAB](https://www.mathworks.com/products/matlab.html),
  [Simulink&reg;](https://www.mathworks.com/products/simulink.html),
  [Simscape](https://www.mathworks.com/products/simscape.html),
  [Simscape Driveline&trade;](https://www.mathworks.com/products/simscape-driveline.html),
  [Simscape Electrical&trade;](https://www.mathworks.com/products/simscape-electrical.html),
  [Stateflow&reg;](https://www.mathworks.com/products/stateflow.html),
  [Powertrain Blockset](https://www.mathworks.com/products/powertrain.html)
- Optional:
  [Parallel Computing Toolbox&trade;](https://www.mathworks.com/products/parallel-computing.html)

Links

- Repository: https://github.com/mathworks/Simscape-Hybrid-Electric-Vehicle-Model/tree/R2022a

### What will be New in Version 1.3

- Required MATLAB release is R2022a or newer.
- Simulink model files are saved in `mdl` format.

## For MATLAB R2021a and R2021b

Power-Split HEV version 1.2 is available.

- Required:
  [MATLAB](https://www.mathworks.com/products/matlab.html),
  [Simulink&reg;](https://www.mathworks.com/products/simulink.html),
  [Simscape](https://www.mathworks.com/products/simscape.html),
  [Simscape Driveline&trade;](https://www.mathworks.com/products/simscape-driveline.html),
  [Simscape Electrical&trade;](https://www.mathworks.com/products/simscape-electrical.html),
  [Stateflow&reg;](https://www.mathworks.com/products/stateflow.html),
  [Powertrain Blockset](https://www.mathworks.com/products/powertrain.html)
- Optional:
  [Parallel Computing Toolbox&trade;](https://www.mathworks.com/products/parallel-computing.html)

Links

- Zip: https://github.com/mathworks/Simscape-Hybrid-Electric-Vehicle-Model/archive/refs/tags/v1.2.0.zip
- Repository: https://github.com/mathworks/Simscape-Hybrid-Electric-Vehicle-Model/tree/R2021a

### What's New in Version 1.2

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

### What's New in Version 1.1

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

Other Updates

- MATLAB R2021a or newer release is required.

## How to Use

Open `HybridElectricVehicle.prj` in MATLAB, and
it will automatically open the Live Script `HEVProject_main_script.mlx`.
The script contains the description of the model and
hyperlinks to models and scripts.

## How to Use in MATLAB Online

You can try this in [MATLAB Online][url_online].
In MATLAB Online, from the **HOME** tab in the toolstrip,
select **Add-Ons** &rarr; **Get Add-Ons**
to open the Add-On Explorer.
Then search for the submission name,
navigate to the submission page,
click **Add** button, and select **Save to MATLAB Drive**.

[url_online]:https://www.mathworks.com/products/matlab-online.html

## License

See [`LICENSE.txt`](LICENSE.txt).

_Copyright 2021-2022 The MathWorks, Inc._
