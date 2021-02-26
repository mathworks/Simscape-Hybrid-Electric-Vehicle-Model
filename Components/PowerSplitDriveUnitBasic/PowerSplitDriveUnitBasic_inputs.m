function [inputSignals, inputBus, t_end] = PowerSplitDriveUnitBasic_inputs(nvpairs)
%% Input Signals for Power-Split Drive Unit

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...  % 1
      'drive_axle' ...  % 2
      'drive_MG2' ...  % 3
      'drive_MG1' ...  % 4
      'lock_axle_while_drive_MG1' ...  % 5: MG1 starts engine while standing still
      'drive_engine' ...  % 6
      'lock_axle_while_drive_engine' ...  % 7: charge battery while standing still
      'lock_axle_while_drive_engine_and_MG1' ...  % 8
      'power_split_drive' ...  % 9
      'drive_all' ...  % 10
    })} = "all_zero";
  nvpairs.PlotParent (1,1) matlab.ui.Figure;
end

input_pattern = nvpairs.InputPattern;

do_plot = false;
if isfield(nvpairs, 'PlotParent')
  do_plot = true;
  parent = nvpairs.PlotParent;
  fig_width = 600;
  fig_height = 600;
end

inputPatternConst = @(c) timetable([c c]', 'RowTimes',seconds([0 1])');

% Axle speed input is off by default.
inputTimeTable.AxleSpd_OnOff_1 = inputPatternConst(0);
inputTimeTable.AxleSpd_rpm = inputPatternConst(0);

switch input_pattern
  case 'all_zero'
    t_end = 1;
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.EngTrqCmd_Nm = inputPatternConst(0);
    fig_width = 400;
    fig_height = 300;

  case 'drive_axle'
    t_end = 100;
    inputTimeTable.AxleTrq_Nm = timetable([0 -800 0 800 800]', 'RowTimes',seconds([0 10 30 60 t_end])');
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.EngTrqCmd_Nm = inputPatternConst(0);

  case 'drive_MG2'
    t_end = 400;
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = timetable([0 170 170]', 'RowTimes',seconds([0 10 t_end])');
    inputTimeTable.Mg1TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.EngTrqCmd_Nm = timetable([0 150 150]', 'RowTimes',seconds([0 200 t_end])');

  case 'drive_MG1'
    t_end = 30;
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -40 40 40]', 'RowTimes',seconds([0 10 20 t_end])');
    inputTimeTable.EngTrqCmd_Nm = inputPatternConst(0);

  case 'lock_axle_while_drive_MG1'
    t_end = 30;
    inputTimeTable.AxleSpd_OnOff_1 = inputPatternConst(1);
    inputTimeTable.AxleSpd_rpm = inputPatternConst(0);
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -40 40 40]', 'RowTimes',seconds([0 10 20 t_end])');
    inputTimeTable.EngTrqCmd_Nm = inputPatternConst(0);

  case 'drive_engine'
    t_end = 100;
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.EngTrqCmd_Nm = timetable([0 150 150]', 'RowTimes',seconds([0 10 t_end])');

  case 'lock_axle_while_drive_engine'
    t_end = 500;
    inputTimeTable.AxleSpd_OnOff_1 = inputPatternConst(1);
    inputTimeTable.AxleSpd_rpm = inputPatternConst(0);
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -5 -10 -15 -20 -20]', 'RowTimes',seconds([0 100 200 300 400 t_end])');
    inputTimeTable.EngTrqCmd_Nm = timetable([0 120 120]', 'RowTimes',seconds([0 50 t_end])');

  case 'lock_axle_while_drive_engine_and_MG1'
    t_end = 250;
    inputTimeTable.AxleSpd_OnOff_1 = inputPatternConst(1);
    inputTimeTable.AxleSpd_rpm = inputPatternConst(0);
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 40 0 -5 -10 -10]', 'RowTimes',seconds([0 10 30 50 150 t_end])');
    inputTimeTable.EngTrqCmd_Nm = timetable([0 140 140]', 'RowTimes',seconds([0 20 t_end])');

  case 'power_split_drive'
    t_end = 600;
    inputTimeTable.AxleTrq_Nm = timetable([-15 -50 -50]', 'RowTimes',seconds([0 400 t_end])');
    inputTimeTable.Mg2TrqCmd_Nm = timetable([20 20]', 'RowTimes',seconds([0 t_end])');
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -10 -10]', 'RowTimes',seconds([0 300 t_end])');
    inputTimeTable.EngTrqCmd_Nm = timetable([120 120]', 'RowTimes',seconds([0 t_end])');

  case 'drive_all'
    t_end = 600;
    inputTimeTable.AxleTrq_Nm = timetable([-15 -5 -5]', 'RowTimes',seconds([0 300 t_end])');
    inputTimeTable.Mg2TrqCmd_Nm = timetable([30 -10 -10]', 'RowTimes',seconds([0 300 t_end])');
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -10 -10]', 'RowTimes',seconds([0 300 t_end])');
    inputTimeTable.EngTrqCmd_Nm = timetable([100 100]', 'RowTimes',seconds([0 t_end])');

end

%%

% inputSignals and inputBus workspace variables defined below are used
% in the From Workspace block.

inputSignals.AxleSpd_OnOff = inputTimeTable.AxleSpd_OnOff_1;
inputSignals.AxleSpd_OnOff.Properties.VariableNames = {'AxleSpd_OnOff'};
inputSignals.AxleSpd_OnOff.Properties.VariableUnits = {'1'};
inputSignals.AxleSpd_OnOff.Properties.VariableContinuity = {'step'};
inputBusElem(1) = Simulink.BusElement;
inputBusElem(1).Name = 'AxleSpd_OnOff';  % must match inputSignals struct's member
inputBusElem(1).Unit = '1';

inputSignals.AxleSpd = inputTimeTable.AxleSpd_rpm;
inputSignals.AxleSpd.Properties.VariableNames = {'AxleSpd'};
inputSignals.AxleSpd.Properties.VariableUnits = {'rpm'};
inputSignals.AxleSpd.Properties.VariableContinuity = {'step'};
inputBusElem(2) = Simulink.BusElement;
inputBusElem(2).Name = 'AxleSpd';
inputBusElem(2).Unit = 'rpm';

inputSignals.AxleTrq = inputTimeTable.AxleTrq_Nm;
inputSignals.AxleTrq.Properties.VariableNames = {'AxleTrq'};
inputSignals.AxleTrq.Properties.VariableUnits = {'N*m'};
inputSignals.AxleTrq.Properties.VariableContinuity = {'step'};
inputBusElem(3) = Simulink.BusElement;
inputBusElem(3).Name = 'AxleTrq';
inputBusElem(3).Unit = 'N*m';

inputSignals.Mg2TrqCmd = inputTimeTable.Mg2TrqCmd_Nm;
inputSignals.Mg2TrqCmd.Properties.VariableNames = {'Mg2TrqCmd'};
inputSignals.Mg2TrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.Mg2TrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(4) = Simulink.BusElement;
inputBusElem(4).Name = 'Mg2TrqCmd';
inputBusElem(4).Unit = 'N*m';

inputSignals.Mg1TrqCmd = inputTimeTable.Mg1TrqCmd_Nm;
inputSignals.Mg1TrqCmd.Properties.VariableNames = {'Mg1TrqCmd'};
inputSignals.Mg1TrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.Mg1TrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(5) = Simulink.BusElement;
inputBusElem(5).Name = 'Mg1TrqCmd';
inputBusElem(5).Unit = 'N*m';

inputSignals.EngTrqCmd = inputTimeTable.EngTrqCmd_Nm;
inputSignals.EngTrqCmd.Properties.VariableNames = {'EngTrqCmd'};
inputSignals.EngTrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.EngTrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(6) = Simulink.BusElement;
inputBusElem(6).Name = 'EngTrqCmd';
inputBusElem(6).Unit = 'N*m';

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.AxleSpd_OnOff, ...
    inputSignals.AxleSpd, ...
    inputSignals.AxleTrq, ...
    inputSignals.Mg2TrqCmd, ...
    inputSignals.Mg1TrqCmd, ...
    inputSignals.EngTrqCmd );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.GridVisible = 'on';
  parent.Position(3:4) = [fig_width fig_height];
end

end  % function
