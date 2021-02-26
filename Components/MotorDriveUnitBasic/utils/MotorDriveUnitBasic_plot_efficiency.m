function fig = MotorDriveUnitBasic_plot_efficiency( nvpair )

% Copyright 2021 The MathWorks, Inc.

%% Process arguments

arguments
  nvpair.trq_max_Nm (1,1) double {mustBePositive} = 163;
  nvpair.spd_max_rpm (1,1) double {mustBePositive} = 17000;
  nvpair.power_max_kW (1,1) double {mustBePositive} = 53;
  nvpair.efficiency_pct (1,1) double {mustBePositive} = 95;
  nvpair.spd_eff_rpm (1,1) double {mustBeNonnegative} = 2000;
  nvpair.trq_eff_Nm (1,1) double {mustBeNonnegative} = 50;
  nvpair.iron_to_nominal_ratio (1,1) double {mustBeNonnegative} = 0.1;
  nvpair.elec_loss_const_W (1,1) double {mustBePositive} = 40;
  nvpair.k_damp_Nm_per_radPerS (1,1) double {mustBeNonnegative} = 0.05;
  nvpair.contour_levels_pct (1,:) double {mustBeNonnegative} = [1 60 80 90 92 94 96 97 98 99];
  nvpair.divs (1,1) {mustBeInteger, mustBePositive} = 500;
end

trq_max_Nm = nvpair.trq_max_Nm;
spd_max_rpm = nvpair.spd_max_rpm;
power_max_W = 1000* nvpair.power_max_kW;
elec_loss_const_W = nvpair.elec_loss_const_W;
eff = nvpair.efficiency_pct/100;
spd_eff_rpm = nvpair.spd_eff_rpm;
spd_eff_radps = spd_eff_rpm*2*pi/60;
trq_eff_Nm = nvpair.trq_eff_Nm;
iron_to_nominal_ratio = nvpair.iron_to_nominal_ratio;
k_damp = nvpair.k_damp_Nm_per_radPerS;
contour_levels = nvpair.contour_levels_pct;
divs = nvpair.divs;

%% Derived parameters


mechpow_eff = spd_eff_radps*trq_eff_Nm;
total_loss_eff = mechpow_eff/eff - mechpow_eff;
nominal_loss_eff = (1/eff - 1)*mechpow_eff;
iron_loss_eff = iron_to_nominal_ratio*nominal_loss_eff;
copper_loss_eff = total_loss_eff - iron_loss_eff;

k_copper = copper_loss_eff/trq_eff_Nm^2;
k_iron = iron_loss_eff/spd_eff_radps^2;

%% Plot

% x-axis
w_rpm_vec = linspace(1, spd_max_rpm, divs);
w_vec = w_rpm_vec/60*2*pi;  % rad/s

% y-axis
trq_vec = linspace(0, trq_max_Nm, divs)';

trq_max_envelope = min(power_max_W ./ w_vec, trq_max_Nm);

% Calculation below is done in x-y mesh.
[w, trq] = meshgrid(w_vec, trq_vec);

% A mask matrix with 1 for valid, 0 for invalid regions.
% This is later multiplied to the efficiency matrix
% to set regions over the maximum power to 0.
valid_region_mat = trq < trq_max_envelope;

% Fixed electrical loss
Pb = elec_loss_const_W*ones(divs, divs);

kc = k_copper;  % Copper loss coefficient
ki = k_iron;  % Iron loss coefficient
kd = k_damp;  % Rotor friction coefficient

trq_elec = abs(trq) - kd*w;  % Steady state
Lc = kc*trq_elec.^2;  % Copper loss model
Li = ki*w.^2;  % Iron loss model
L_elec = Pb + Lc + Li;  % Total electrical loss
mech_power = trq.*w;  % Mechanical power
eff = 100 * abs(mech_power) ./(L_elec + abs(mech_power));  % Efficiency in percent

% Apply mask
eff = valid_region_mat .* eff;

fig = figure;  hold on
contourf(w_rpm_vec, trq_vec, eff, contour_levels, "ShowText","on")
plot(w_rpm_vec, trq_max_envelope, "LineWidth",3, "Color","blue")
sct = scatter(spd_eff_rpm, trq_eff_Nm, 'x');
sct.Marker = 'x';
sct.LineWidth = 1;
sct.SizeData = 100;
sct.MarkerEdgeColor = 'black';
xlim([0 spd_max_rpm])
ylim([0 trq_max_Nm])
xlabel("Speed (rpm)")
ylabel("Torque (Nm)")
title("Overall Efficiency of Motor Drive Unit (%)")

end
