function [inputSignals, inputBus, t_end] = Vehicle1DBasic_inputs(nvpairs)
%% Input Signals for Simple 1D Vehicle

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'coastdown' ...
      'braking' ...
      'acceleration' ...
    })} = "all_zero"
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
    t_end = 1;
    inputTimeTable.BrakeForce_N = inputPatternConst(0);
    inputTimeTable.RoadGrade_pct = inputPatternConst(0);
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    fig_width = 200;
    fig_height = 200;

  case 'coastdown'
    % Inputs below are the same as the above All Zero case, but the initial
    % vehicle velocity is different and it is defined in the corresponding
    % Live Script.
    t_end = 400;
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.BrakeForce_N = inputPatternConst(0);
    inputTimeTable.RoadGrade_pct = inputPatternConst(0);

  case 'braking'
    t_end = 30;
    inputTimeTable.AxleTrq_Nm = inputPatternConst(0);
    inputTimeTable.BrakeForce_N = timetable([7000 2000 0 0]', 'RowTimes',seconds([0 10 20 t_end])');
    inputTimeTable.RoadGrade_pct = inputPatternConst(-30);

  case 'acceleration'
    t_end = 100;
    inputTimeTable.AxleTrq_Nm = timetable([1000 0 0]', 'RowTimes',seconds([0 40 t_end])');
    inputTimeTable.BrakeForce_N = timetable([0 4000 3000 1000 1000]', 'RowTimes',seconds([0 50 55 65 t_end])');
    inputTimeTable.RoadGrade_pct = timetable([0 20 0 0]', 'RowTimes',seconds([0 20 30 t_end])');

end

%%

% inputSignals and inputBus workspace variables defined below are used
% in the From Workspace block.

inputSignals.AxleTrq = inputTimeTable.AxleTrq_Nm;
inputSignals.AxleTrq.Properties.VariableNames = {'AxleTrq'};
inputSignals.AxleTrq.Properties.VariableUnits = {'N*m'};
inputSignals.AxleTrq.Properties.VariableContinuity = {'step'};
inputBusElem(1) = Simulink.BusElement;
inputBusElem(1).Name = 'AxleTrq';
inputBusElem(1).Unit = 'N*m';

inputSignals.BrakeForce = inputTimeTable.BrakeForce_N;
inputSignals.BrakeForce.Properties.VariableNames = {'BrakeForce'};
inputSignals.BrakeForce.Properties.VariableUnits = {'N'};
inputSignals.BrakeForce.Properties.VariableContinuity = {'step'};
inputBusElem(2) = Simulink.BusElement;
inputBusElem(2).Name = 'BrakeForce';
inputBusElem(2).Unit = 'N';

inputSignals.RoadGrade = inputTimeTable.RoadGrade_pct;
inputSignals.RoadGrade.Properties.VariableNames = {'RoadGrade'};
inputSignals.RoadGrade.Properties.VariableUnits = {'%'};
inputSignals.RoadGrade.Properties.VariableContinuity = {'step'};
inputBusElem(3) = Simulink.BusElement;
inputBusElem(3).Name = 'RoadGrade';
inputBusElem(3).Unit = '%';

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.AxleTrq, ...
    inputSignals.BrakeForce, ...
    inputSignals.RoadGrade );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.GridVisible = 'on';
  parent.Position(3:4) = [fig_width fig_height];
end

end  % function
