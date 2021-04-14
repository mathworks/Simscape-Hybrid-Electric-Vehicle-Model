# Simscape Hybrid Electric Vehicle Project

Version 1

Copyright 2021 The MathWorks, Inc.

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
a MATLAB Project and
some components come with their own test setups.

![Model Screenshot](utils/PowerSplitHEV_SpeedTracking.png)

![Plot of Simulation Result](utils/simulation_result.png)

## Tool Requirements

Supported MATLAB Version: R2020b or newer releases

Required: MATLAB, Simulink, Stateflow, Powertrain Blockset,
Simscape, Simscape Driveline, Simscape Electrical

## How to Use

Open `HybridElectricVehicle.prj` in MATLAB, and
it will automatically open the Live Script `HEV_main_script.mlx`.
The script contains the description of the model and
hyperlinks to models and scripts.
