function f = plotCustomEngineCurves(blockpath)
%%

% Copyright 2022 The MathWorks, Inc.

PeakTrq_Nm = getParamInfo(blockpath, "PeakTorque", "N*m");

RevAtPeakTrq_rpm = getParamInfo(blockpath, "PeakTorqueSpeed", "rpm");
RevAtPeakTrq_radps = RevAtPeakTrq_rpm * pi/30;

PeakPwr_kW = getParamInfo(blockpath, "PeakPower", "kW");
PeakPwr_W = PeakPwr_kW * 1000;

RevAtPeakPwr_radps = ...
  (3*PeakPwr_W + sqrt(PeakPwr_W*(9*PeakPwr_W - 8*PeakTrq_Nm*RevAtPeakTrq_radps))) ...
  / (4*PeakTrq_Nm);
RevAtPeakPwr_rpm = RevAtPeakPwr_radps * 30/pi;

RevMax_rpm = getParamInfo(blockpath, "MaxSpeed", "rpm");

Stall_rpm = getParamInfo(blockpath, "StallSpeed", "rpm");

Smooth_rpm = getParamInfo(blockpath, "SmoothingWidth", "rpm");

% Normalized maximum engine speed
w_NormMax = RevMax_rpm / RevAtPeakPwr_rpm;

% Normalized engine speed at peak torque
w_NPT = RevAtPeakTrq_rpm / RevAtPeakPwr_rpm;

s1 = (3 - 4*w_NPT)/(2*(1 - w_NPT));
s2 = w_NPT/(1 - w_NPT);
s3 = 1/(2*(w_NPT - 1));

%% Normalized values
% Smoothing factor is not applied.

w_Norm = linspace(0, w_NormMax, 1000)';

pwr_Norm = s1*w_Norm + s2*w_Norm.^2 + s3*w_Norm.^3;

trq_Norm = 2/(3 - w_NPT)*(s1 + s2*w_Norm + s3*w_Norm.^2);

%% Values with physical units
% Smoothing factor is applied.

w_rpm = w_Norm.*RevAtPeakPwr_rpm;

smoothing = tanh(4 * (w_rpm - Stall_rpm)./Smooth_rpm);
smoothing( w_rpm < Stall_rpm ) = 0;

prw_kW = smoothing.*PeakPwr_kW.*pwr_Norm;

trq_Nm = smoothing.*PeakTrq_Nm.*trq_Norm;

%%

f = figure;
f.Position(3:4) = [400 360];  % width height

yyaxis left
hold on
plot(w_rpm, trq_Nm, "LineWidth",2)
ylim([0 ceil(PeakTrq_Nm*1.02)])
ylabel("Engine Torque (N*m)")

yyaxis right
hold on
plot(w_rpm, prw_kW, "LineWidth",1.5, "LineStyle","--")
ylim([0 ceil(PeakPwr_kW*1.02)])
ylabel("Engine Power (kW)")

xline(RevAtPeakTrq_rpm)
xline(RevAtPeakPwr_rpm)

xlim([0 RevMax_rpm])
xlabel("Engine Speed (rpm)")

legend([ ...
  "Torque (left): Peak at " + RevAtPeakTrq_rpm + "rpm", ...
  "Power (right): Peak at " + ceil(RevAtPeakPwr_rpm) + "rpm"], ...
  "Location","southeast")

end  % function

function val = getParamInfo(blockPath, paramString, unitString)
arguments
  blockPath
  paramString {mustBeTextScalar}
  unitString {mustBeTextScalar}
end
val = evalin('base', get_param(blockPath, paramString));
val_unit = get_param(blockPath, paramString+"_unit");
assert(val_unit == unitString)
end  % function
