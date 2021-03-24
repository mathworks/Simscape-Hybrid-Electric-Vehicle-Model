%% Setup Script for Power-Split HEV with Speed Tracking

% Copyright 2021 The MathWorks, Inc.

%% Select drive pattern

PowerSplitHEV_SpeedTracking_select_accel_decel
% PowerSplitHEV_SpeedTracking_select_simple_pattern
% PowerSplitHEV_SpeedTracking_select_ftp75

%% Load default parameters

% Plant
PowerSplitHEV_params

% Controller/Driver - load this after plant
DriverHEVPowerSplit_params
