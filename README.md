# Hybrid Electric Vehicle Model in Simscape&trade;

Version 1

Copyright 2021 The MathWorks, Inc.

https://www.mathworks.com/

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
For more elaborate models of vehicles with control algorithms,
please see dedicated toolboxes such as Powertrain Blockset&trade;.

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

The HEV model and its components are managed in
a MATLAB project and
some components come with their own test setups.

![Model Screenshot](utils/PowerSplitHEV_SpeedTracking.png)

![Plot of Simulation Result](utils/simulation_result.png)

## Tool Requirements

Supported MATLAB version: R2020b or newer releases

Required:
[MATLAB](https://www.mathworks.com/products/matlab.html),
[Simulink&reg;](https://www.mathworks.com/products/simulink.html),
[Stateflow&reg;](https://www.mathworks.com/products/stateflow.html),
[Powertrain Blockset](https://www.mathworks.com/products/powertrain.html),
[Simscape](https://www.mathworks.com/products/simscape.html),
[Simscape Driveline&trade;](https://www.mathworks.com/products/simscape-driveline.html),
[Simscape Electrical&trade;](https://www.mathworks.com/products/simscape-electrical.html)

## How to Use

Open `HybridElectricVehicle.prj` in MATLAB, and
it will automatically open the Live Script `HEV_main_script.mlx`.
The script contains the description of the model and
hyperlinks to models and scripts.

## License

See [`LICENSE.txt`](LICENSE.txt).
