function [inputSignals, inputBus, t_end] = MotorGenerator2Basic_inputs(nvpairs)
%% Input Signals for Motor Generator 2

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'torque_drive' ...
      'torque_brake' ...
    })} = 'all_zero'
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

input_pattern = nvpairs.InputPattern;

do_plot = false;
if isfield(nvpairs, 'PlotParent')
  do_plot = true;
  parent = nvpairs.PlotParent;
  fig_width = 600;
  fig_height = 400;
end

inputPatternConst = @(c) timetable([c c]', 'RowTimes',seconds([0 1])');

% By default, the rotor speed and the speed command are not manipulated.
inputTimeTable.RotorSpd_OnOff_1 = inputPatternConst(0);
inputTimeTable.RotorSpd_rpm = inputPatternConst(0);
inputTimeTable.SpdCmd_rpm = inputPatternConst(0);

switch input_pattern
  case 'all_zero'
    t_end = 1;
    inputTimeTable.RotorTrq_Nm = inputPatternConst(0);
    inputTimeTable.TrqCmd_Nm = inputPatternConst(0);
    fig_width = 300;
    fig_height = 300;

  case 'torque_drive'
    t_end = 800;
    inputTimeTable.RotorTrq_Nm =  timetable([0 -100 -300 -500 -500]', 'RowTimes',seconds([0 500 600 700 t_end])');
    inputTimeTable.TrqCmd_Nm = timetable([0 160 160]', 'RowTimes',seconds([0 100 t_end])');

  case 'torque_brake'
    t_end = 300;
    inputTimeTable.RotorTrq_Nm = timetable([0 50 50]', 'RowTimes',seconds([0 100 t_end])');
    inputTimeTable.TrqCmd_Nm = timetable([0 -10 -20 -20]', 'RowTimes',seconds([0 150 250 t_end])');

end

%%

% inputSignals and inputBus workspace variables defined below are used
% in the From Workspace block.

inputSignals.RotorSpd_OnOff = inputTimeTable.RotorSpd_OnOff_1;
inputSignals.RotorSpd_OnOff.Properties.VariableNames = {'RotorSpd_OnOff'};
inputSignals.RotorSpd_OnOff.Properties.VariableUnits = {'1'};
inputSignals.RotorSpd_OnOff.Properties.VariableContinuity = {'step'};
inputBusElem(1) = Simulink.BusElement;
inputBusElem(1).Name = 'RotorSpd_OnOff';  % must match inputSignals struct's member
inputBusElem(1).Unit = '1';

inputSignals.RotorSpd = inputTimeTable.RotorSpd_rpm;
inputSignals.RotorSpd.Properties.VariableNames = {'RotorSpd'};
inputSignals.RotorSpd.Properties.VariableUnits = {'rpm'};
inputSignals.RotorSpd.Properties.VariableContinuity = {'step'};
inputBusElem(2) = Simulink.BusElement;
inputBusElem(2).Name = 'RotorSpd';
inputBusElem(2).Unit = 'rpm';

inputSignals.RotorTrq = inputTimeTable.RotorTrq_Nm;
inputSignals.RotorTrq.Properties.VariableNames = {'RotorTrq'};
inputSignals.RotorTrq.Properties.VariableUnits = {'N*m'};
inputSignals.RotorTrq.Properties.VariableContinuity = {'step'};
inputBusElem(3) = Simulink.BusElement;
inputBusElem(3).Name = 'RotorTrq';
inputBusElem(3).Unit = 'N*m';

inputSignals.SpdCmd = inputTimeTable.SpdCmd_rpm;
inputSignals.SpdCmd.Properties.VariableNames = {'SpdCmd'};
inputSignals.SpdCmd.Properties.VariableUnits = {'rpm'};
inputSignals.SpdCmd.Properties.VariableContinuity = {'step'};
inputBusElem(4) = Simulink.BusElement;
inputBusElem(4).Name = 'SpdCmd';
inputBusElem(4).Unit = 'rpm';

inputSignals.TrqCmd = inputTimeTable.TrqCmd_Nm;
inputSignals.TrqCmd.Properties.VariableNames = {'TrqCmd'};
inputSignals.TrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.TrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(5) = Simulink.BusElement;
inputBusElem(5).Name = 'TrqCmd';
inputBusElem(5).Unit = 'N*m';

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.RotorSpd_OnOff, ...
    inputSignals.RotorSpd, ...
    inputSignals.RotorTrq, ...
    inputSignals.SpdCmd, ...
    inputSignals.TrqCmd );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.GridVisible = 'on';
  parent.Position(3:4) = [fig_width fig_height];
end

end  % function
