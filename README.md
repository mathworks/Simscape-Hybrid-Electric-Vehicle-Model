# Hybrid Electric Vehicle Model in Simscape&trade;

Version 1

Copyright 2021 The MathWorks, Inc.

https://www.mathworks.com/

## Introduction

This is a Hybrid Electric Vehicle (HEV) model in Simscape,
suitable for the system level simulation of
longitudinal vehicle behavior as it runs faster than real time.
The model consists of components such as motor, engine,
power-split device, and so on,
and it is built in a modular manner using Subsystem Reference
demonstrating a workflow where components are built and tested
individually and also they can be easily integrated into
a complete vehicle system model.

The HEV model and its components are managed in
a MATLAB&reg; project and
some components come with their own test setups.

![Model Screenshot](utils/PowerSplitHEV_SpeedTracking.png)

![Plot of Simulation Result](utils/simulation_result.png)

## Tool Requirements

Supported MATLAB version: R2020b or newer releases

Required:
[MATLAB](https://www.mathworks.com/products/matlab.html),
[Simulink&reg;](https://www.mathworks.com/products/simulink.html),
[Stateflow&reg;](https://www.mathworks.com/products/stateflow.html),
[Powertrain Blockset&trade;](https://www.mathworks.com/products/powertrain.html),
[Simscape&trade;](https://www.mathworks.com/products/simscape.html),
[Simscape Driveline&trade;](https://www.mathworks.com/products/simscape-driveline.html),
[Simscape Electrical&trade;](https://www.mathworks.com/products/simscape-electrical.html)

## How to Use

Open `HybridElectricVehicle.prj` in MATLAB, and
it will automatically open the Live Script `HEV_main_script.mlx`.
The script contains the description of the model and
hyperlinks to models and scripts.

## License

See [`LICENSE.txt`](LICENSE.txt).
