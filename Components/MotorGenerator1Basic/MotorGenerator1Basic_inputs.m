function [inputSignals, inputBus, t_end] = MotorGenerator1Basic_inputs(nvpairs)
%% Input Signals for Motor Generator 1 Component

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'generate' ...
      'no_engine_reverse' ...
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
    t_end = 10;
    inputTimeTable.EngTrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = inputPatternConst(0);
    fig_width = 200;
    fig_height = 200;

  case 'generate'
    t_end = 500;
    inputTimeTable.EngTrqCmd_Nm = timetable([0 150 150]', 'RowTimes',seconds([0 50 t_end])');
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -10 -20 -30 -40 -40]', 'RowTimes',seconds([0 100 200 300 400 t_end])');
    fig_width = 600;
    fig_height = 300;

  case 'no_engine_reverse'
    t_end = 800;
    inputTimeTable.EngTrqCmd_Nm = timetable([0 -100 -200 -300 -300]', 'RowTimes',seconds([0 500 600 700 t_end])');
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 40 40]', 'RowTimes',seconds([0 100 t_end])');
    fig_width = 600;
    fig_height = 300;

end

%%

% inputSignals and inputBus workspace variables defined below are used
% in the From Workspace block.

inputSignals.EngTrqCmd = inputTimeTable.EngTrqCmd_Nm;
inputSignals.EngTrqCmd.Properties.VariableNames = {'EngTrqCmd'};
inputSignals.EngTrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.EngTrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(1) = Simulink.BusElement;
inputBusElem(1).Name = 'EngTrqCmd';
inputBusElem(1).Unit = 'N*m';

inputSignals.Mg1TrqCmd = inputTimeTable.Mg1TrqCmd_Nm;
inputSignals.Mg1TrqCmd.Properties.VariableNames = {'Mg1TrqCmd'};
inputSignals.Mg1TrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.Mg1TrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(2) = Simulink.BusElement;
inputBusElem(2).Name = 'Mg1TrqCmd';
inputBusElem(2).Unit = 'N*m';

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.EngTrqCmd, ...
    inputSignals.Mg1TrqCmd );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.GridVisible = 'on';
  parent.Position(3:4) = [fig_width fig_height];
end

end  % function
