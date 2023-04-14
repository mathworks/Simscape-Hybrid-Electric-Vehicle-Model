function PowerSplitDriveUnit_Component_plotInputs()
% Plots torque commands defined in the blocks in the harness model.
% This assumes that the model is already open.

% Copyright 2023 The MathWorks, Inc.

mdl = "PowerSplitDriveUnit_Component_harness_model";

tEnd = eval(get_param(mdl, "StopTime"));

blkPath = mdl + "/Engine torque command";
dataPoints = eval(get_param(blkPath, "dataPoints"));
deltaT = eval(get_param(blkPath, "deltaT"));
sig = SignalDesigner("Continuous");
sig.XYData = dataPoints;
sig.DeltaX = deltaT;
update(sig)
EngTimeData = sig.Data.X;
EngTrqCmd = sig.Data.Y;

blkPath = mdl + "/MG1 torque command";
dataPoints = eval(get_param(blkPath, "dataPoints"));
deltaT = eval(get_param(blkPath, "deltaT"));
sig = SignalDesigner("Continuous");
sig.XYData = dataPoints;
sig.DeltaX = deltaT;
update(sig)
MG1TimeData = sig.Data.X;
MG1TrqCmd = sig.Data.Y;

blkPath = mdl + "/MG2 torque command";
dataPoints = eval(get_param(blkPath, "dataPoints"));
deltaT = eval(get_param(blkPath, "deltaT"));
sig = SignalDesigner("Continuous");
sig.XYData = dataPoints;
sig.DeltaX = deltaT;
update(sig)
MG2TimeData = sig.Data.X;
MG2TrqCmd = sig.Data.Y;

blkPath = mdl + "/Road grade";
dataPoints = eval(get_param(blkPath, "dataPoints"));
deltaT = eval(get_param(blkPath, "deltaT"));
sig = SignalDesigner("Continuous");
sig.XYData = dataPoints;
sig.DeltaX = deltaT;
update(sig)
GradeTimeData = sig.Data.X;
GradeData = sig.Data.Y;

blkPath = mdl + "/Brake force";
dataPoints = eval(get_param(blkPath, "dataPoints"));
deltaT = eval(get_param(blkPath, "deltaT"));
sig = SignalDesigner("Continuous");
sig.XYData = dataPoints;
sig.DeltaX = deltaT;
update(sig)
BrakeForceTimeData = sig.Data.X;
BrakeForceData = sig.Data.Y;

figure

ti = tiledlayout(5, 1);
ti.TileSpacing = 'compact';
ti.Padding = 'compact';

nexttile

hold on
grid on
title("MG2 torque command")
plot(MG2TimeData, MG2TrqCmd, LineWidth=2);
setMinimumYRange(gca, MG2TrqCmd, dy_threshold=0.02)
xlim([0 tEnd])
ylabel("(N*m)")

nexttile

hold on
grid on
title("MG1 torque command")
plot(MG1TimeData, MG1TrqCmd, LineWidth=2);
setMinimumYRange(gca, MG1TrqCmd, dy_threshold=0.02)
xlim([0 tEnd])
ylabel("(N*m)")

nexttile

hold on
grid on
title("Engine torque command")
plot(EngTimeData, EngTrqCmd, LineWidth=2);
setMinimumYRange(gca, EngTrqCmd, dy_threshold=0.02)
xlim([0 tEnd])
ylabel("(N*m)")

nexttile

hold on
grid on
title("Brake force")
plot(BrakeForceTimeData, BrakeForceData, LineWidth=2);
setMinimumYRange(gca, BrakeForceData, dy_threshold=0.02)
xlim([0 tEnd])
ylabel("(N)")

nexttile

hold on
grid on
title("Road grade")
plot(GradeTimeData, GradeData, LineWidth=2);
setMinimumYRange(gca, GradeData, dy_threshold=0.02)
xlim([0 tEnd])
ylabel("(%)")

xlabel("Time (s)")

end  % function
