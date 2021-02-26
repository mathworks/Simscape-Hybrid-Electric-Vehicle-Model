function [inputSignals, inputBus, t_end] = DriverAndEnvironment_road_grade_pattern(nvpairs)
%% Road Grade Pattern Input Signal

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'flat' ...
      'uphill_3_percent' ...
      'downhill_5_percent' ...
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

t_end = 1;

switch input_pattern
  case {'all_zero', 'flat'}
    inputTimeTable.RoadGrade_pct = inputPatternConst(0);

  case 'uphill_3_percent'
    inputTimeTable.RoadGrade_pct = inputPatternConst(3);

  case 'downhill_5_percent'
    inputTimeTable.RoadGrade_pct = inputPatternConst(-5);

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

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.RoadGrade );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.GridVisible = 'on';
end

end  % function
