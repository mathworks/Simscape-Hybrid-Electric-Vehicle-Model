function [inputSignals, inputBus, opt] = DriverAndEnvironment_road_grade_pattern(nvpairs)
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
  opt.fig_width = 300;
  opt.fig_height = 200;
  opt.line_width = 2;
end

inputPatternConst = @(c) timetable([c c]', 'RowTimes',seconds([0 1])');

t_end = 1;

switch input_pattern
  case {'all_zero', 'flat'}
    RoadGrade = inputPatternConst(0);

  case 'uphill_3_percent'
    RoadGrade = inputPatternConst(3);

  case 'downhill_5_percent'
    RoadGrade = inputPatternConst(-5);

end

opt.t_end = t_end;

%%

% inputSignals and inputBus workspace variables defined below are used
% in the From Workspace block.

RoadGrade.Properties.VariableNames = {'RoadGrade'};
RoadGrade.Properties.VariableUnits = {'%'};
RoadGrade.Properties.VariableContinuity = {'continuous'};

inputSignals.RoadGrade = RoadGrade;

inputBus = Simulink.Bus;
inputBus.Elements(1) = Simulink.BusElement;
inputBus.Elements(1).Name = 'RoadGrade';
inputBus.Elements(1).Unit = '%';

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.RoadGrade );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',opt.line_width );
  stk.GridVisible = 'on';
end

end  % function
