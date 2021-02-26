function fig = Vehicle1DBasic_plot_resisting_force( nvpairs )
% plots the resisting force.

% Copyright 2021 The MathWorks, Inc.

arguments
  % Block parameters
  nvpairs.VehicleMass_kg (1,1) double {mustBePositive} = 1800
  nvpairs.RoadLoadA_N (1,1) double {mustBePositive} = 100
  nvpairs.RoadLoadB_N_per_kph (1,1) double {mustBeNonnegative} = 0
  nvpairs.RoadLoadC_N_per_kph2 (1,1) double {mustBePositive} = 0.035
  nvpairs.GravitationalAcceleration_m_per_s2 (1,1) double {mustBePositive} = 9.81

  % x-axis, vehicle speed in km/hr
  nvpairs.VehicleSpeedVector_kph (1,:) double = linspace(0, 150, 400)

  nvpairs.RoadGradeVector_pct (1,:) double ...
    { mustBeGreaterThan(nvpairs.RoadGradeVector_pct, -100), ...
      mustBeLessThan(nvpairs.RoadGradeVector_pct, 100)} = [40, 20, 0]
end

M_e_kg = nvpairs.VehicleMass_kg;
A_rl = nvpairs.RoadLoadA_N;
B_rl = nvpairs.RoadLoadB_N_per_kph;
C_rl = nvpairs.RoadLoadC_N_per_kph2;
grav = nvpairs.GravitationalAcceleration_m_per_s2;

v_kph = nvpairs.VehicleSpeedVector_kph;
grade_pct = nvpairs.RoadGradeVector_pct;

v_threshold_kph = 0.1;
v_norm_kph = 0.5;

incline_angle_rad = atan(grade_pct/100);
incline_angle_deg = round(incline_angle_rad/pi*180, 1);  % for plotting

F_roll = A_rl + B_rl*v_kph.*tanh(v_kph./v_threshold_kph);
F_airdrag = C_rl*v_kph.^2;
F_resist_flat = tanh(v_kph/v_norm_kph).*(F_roll + F_airdrag);

fig = figure;  hold on;  grid on
fig.Position(3:4) = [400 300];  % width height
numGrades = length(grade_pct);
tmp = [grade_pct', incline_angle_deg'];
l_str = strings(numGrades, 1);
for i = 1 : numGrades
  l_str(i) = string(tmp(i,1)+"% ("+tmp(i,2)+"deg)");
  F_resist = F_resist_flat + M_e_kg*grav*sin(incline_angle_rad(i));
  plot(v_kph, F_resist, "LineWidth",1.5)
end
lgd = legend(l_str);
title(lgd, "Road grade")
xlabel("Vehicle Speed (km/hr)")
ylabel("Resisting Force (N)")
title("Road-Load Resisting Force")

end
