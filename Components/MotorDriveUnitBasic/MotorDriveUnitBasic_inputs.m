function [inputSignals, inputBus, t_end] = MotorDriveUnitBasic_inputs(nvpairs)
%% Input Signals for Motor Drive Unit

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'drive' ...
    })} = 'all_zero'
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

input_pattern = nvpairs.InputPattern;

do_plot = false;
if isfield(nvpairs, 'PlotParent')
  do_plot = true;
  parent = nvpairs.PlotParent;
end

inputPatternConst = @(c) timetable([c c]', 'RowTimes',seconds([0 1])');

switch input_pattern
  case 'all_zero'
    t_end = 1;
    inputTimeTable.Spd_OnOff_1 = inputPatternConst(0);
    inputTimeTable.Spd_rpm = inputPatternConst(0);
    inputTimeTable.Trq_Nm = inputPatternConst(0);
    inputTimeTable.TrqCmd_Nm = inputPatternConst(0);
    fig_width = 300;
    fig_height = 200;

  case 'drive'
    t_end = 40;
    inputTimeTable.Spd_OnOff_1 = inputPatternConst(0);
    inputTimeTable.Spd_rpm = inputPatternConst(0);
    inputTimeTable.Trq_Nm = timetable([0 100 200 0 0]', 'RowTimes',seconds([0 10 20 30 t_end])');
    inputTimeTable.TrqCmd_Nm = timetable([0 50 -30 0 0]', 'RowTimes',seconds([0 10 20 30 t_end])');
    fig_width = 600;
    fig_height = 400;

end

%%

% inputSignals and inputBus workspace variables defined below are used
% in the From Workspace block.

inputSignals.Spd_OnOff = inputTimeTable.Spd_OnOff_1;
inputSignals.Spd_OnOff.Properties.VariableNames = {'Spd_OnOff'};
inputSignals.Spd_OnOff.Properties.VariableUnits = {'1'};
inputSignals.Spd_OnOff.Properties.VariableContinuity = {'step'};
inputBusElem(1) = Simulink.BusElement;
inputBusElem(1).Name = 'Spd_OnOff';  % must match inputSignals struct's member
inputBusElem(1).Unit = '1';

inputSignals.Spd = inputTimeTable.Spd_rpm;
inputSignals.Spd.Properties.VariableNames = {'Spd'};
inputSignals.Spd.Properties.VariableUnits = {'rpm'};
inputSignals.Spd.Properties.VariableContinuity = {'step'};
inputBusElem(2) = Simulink.BusElement;
inputBusElem(2).Name = 'Spd';
inputBusElem(2).Unit = 'rpm';

inputSignals.Trq = inputTimeTable.Trq_Nm;
inputSignals.Trq.Properties.VariableNames = {'Trq'};
inputSignals.Trq.Properties.VariableUnits = {'N*m'};
inputSignals.Trq.Properties.VariableContinuity = {'step'};
inputBusElem(3) = Simulink.BusElement;
inputBusElem(3).Name = 'Trq';
inputBusElem(3).Unit = 'N*m';

inputSignals.TrqCmd = inputTimeTable.TrqCmd_Nm;
inputSignals.TrqCmd.Properties.VariableNames = {'TrqCmd'};
inputSignals.TrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.TrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(4) = Simulink.BusElement;
inputBusElem(4).Name = 'TrqCmd';
inputBusElem(4).Unit = 'N*m';

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.Spd_OnOff, ...
    inputSignals.Spd, ...
    inputSignals.Trq, ...
    inputSignals.TrqCmd );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.GridVisible = 'on';
  parent.Position(3:4) = [fig_width fig_height];
end

end  % function
