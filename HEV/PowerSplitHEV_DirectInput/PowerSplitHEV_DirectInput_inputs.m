function [inputSignals, inputBus, t_end] = PowerSplitHEV_DirectInput_inputs(nvpairs)
%% Input Signals for Power-Split HEV Model with Direct Input

% Copyright 2020-2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'power_split_drive' ...
      'downhill_charge' ...
    })} = 'all_zero'
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

input_pattern = nvpairs.InputPattern;

do_plot = false;
if isfield(nvpairs, 'PlotParent')
  do_plot = true;
  parent = nvpairs.PlotParent;
  fig_width = 500;
  fig_height = 300;
end

inputPatternConst = @(c) timetable([c c]', 'RowTimes',seconds([0 1])');

switch input_pattern
  case 'all_zero'
    t_end = 100;
    inputTimeTable.RoadGrade_pct = inputPatternConst(0);
    inputTimeTable.BrakeForce_N = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.Mg1TrqCmd_Nm = inputPatternConst(0);
    inputTimeTable.EngTrqCmd_Nm = inputPatternConst(0);

  case 'power_split_drive'
    t_end = 2000;
    inputTimeTable.RoadGrade_pct = inputPatternConst(0);
    inputTimeTable.BrakeForce_N = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = timetable([20 50 50]', 'RowTimes',seconds([0 1000 t_end])');
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -20 -20]', 'RowTimes',seconds([0 500 t_end])');
    inputTimeTable.EngTrqCmd_Nm = timetable([0 100 100]', 'RowTimes',seconds([0 1500 t_end])');

  case 'downhill_charge'
    t_end = 3000;
    inputTimeTable.RoadGrade_pct = inputPatternConst(-10);
    inputTimeTable.BrakeForce_N = inputPatternConst(0);
    inputTimeTable.Mg2TrqCmd_Nm = timetable([0 -10 -10]', 'RowTimes',seconds([0 1000 t_end])');
    inputTimeTable.Mg1TrqCmd_Nm = timetable([0 -20 -20]', 'RowTimes',seconds([0 2000 t_end])');
    inputTimeTable.EngTrqCmd_Nm = inputPatternConst(0);

end

%%

% inputSignals and inputBus workspace variables defined below are used
% in the From Workspace block.

inputSignals.RoadGrade = inputTimeTable.RoadGrade_pct;
inputSignals.RoadGrade.Properties.VariableNames = {'RoadGrade'};
inputSignals.RoadGrade.Properties.VariableUnits = {'%'};
inputSignals.RoadGrade.Properties.VariableContinuity = {'step'};
inputBusElem(1) = Simulink.BusElement;
inputBusElem(1).Name = 'RoadGrade';
inputBusElem(1).Unit = '%';

inputSignals.BrakeForce = inputTimeTable.BrakeForce_N;
inputSignals.BrakeForce.Properties.VariableNames = {'BrakeForce'};
inputSignals.BrakeForce.Properties.VariableUnits = {'N'};
inputSignals.BrakeForce.Properties.VariableContinuity = {'step'};
inputBusElem(2) = Simulink.BusElement;
inputBusElem(2).Name = 'BrakeForce';
inputBusElem(2).Unit = 'N';

inputSignals.Mg2TrqCmd = inputTimeTable.Mg2TrqCmd_Nm;
inputSignals.Mg2TrqCmd.Properties.VariableNames = {'Mg2TrqCmd'};
inputSignals.Mg2TrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.Mg2TrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(3) = Simulink.BusElement;
inputBusElem(3).Name = 'Mg2TrqCmd';
inputBusElem(3).Unit = 'N*m';

inputSignals.Mg1TrqCmd = inputTimeTable.Mg1TrqCmd_Nm;
inputSignals.Mg1TrqCmd.Properties.VariableNames = {'Mg1TrqCmd'};
inputSignals.Mg1TrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.Mg1TrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(4) = Simulink.BusElement;
inputBusElem(4).Name = 'Mg1TrqCmd';
inputBusElem(4).Unit = 'N*m';

inputSignals.EngTrqCmd = inputTimeTable.EngTrqCmd_Nm;
inputSignals.EngTrqCmd.Properties.VariableNames = {'EngTrqCmd'};
inputSignals.EngTrqCmd.Properties.VariableUnits = {'N*m'};
inputSignals.EngTrqCmd.Properties.VariableContinuity = {'step'};
inputBusElem(5) = Simulink.BusElement;
inputBusElem(5).Name = 'EngTrqCmd';
inputBusElem(5).Unit = 'N*m';

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.RoadGrade, ...
    inputSignals.BrakeForce, ...
    inputSignals.Mg2TrqCmd, ...
    inputSignals.Mg1TrqCmd, ...
    inputSignals.EngTrqCmd );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.GridVisible = 'on';
  parent.Position(3:4) = [fig_width fig_height];
end

end  % function
