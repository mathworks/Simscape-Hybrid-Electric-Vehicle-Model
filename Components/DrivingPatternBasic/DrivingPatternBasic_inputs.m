function [inputSignals, inputBus, t_end, useKph, useFromWorkspace] = DrivingPatternBasic_inputs(nvpairs)
%% Driving Pattern Input Signals

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'standstill_charge' ...
      'accelerate_decelerate_kph' ...
      'accelerate_decelerate_mph' ...
      'simple_drive_pattern' ...
      'ftp75_mph' ...
    })} = 'all_zero'
  nvpairs.PlotParent (1,1) matlab.ui.Figure
end

input_pattern = nvpairs.InputPattern;

do_plot = false;
if isfield(nvpairs, 'PlotParent')
  do_plot = true;
  parent = nvpairs.PlotParent;
end

% false when using other sources such as Drive Cycle Source block in PTBS
useFromWorkspace = true;

% true for km/hr, false for mi/hr
useKph = true;

inputPatternConst = @(c) timetable([c c]', 'RowTimes',seconds([0 1])');

switch input_pattern
  case 'all_zero'
    t_end = 1; % 100;
    inputSignals.VehSpdRef = inputPatternConst(0);
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputBusElem(1) = Simulink.BusElement;
    inputBusElem(1).Name = 'VehSpdRef';
    inputBusElem(1).Unit = 'km/hr';
    fig_width = 200;
    fig_height = 100;
    line_width = 2;

  case 'standstill_charge'
    t_end = 4000;
    inputSignals.VehSpdRef = inputPatternConst(0);
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputBusElem(1) = Simulink.BusElement;
    inputBusElem(1).Name = 'VehSpdRef';
    inputBusElem(1).Unit = 'km/hr';
    fig_width = 300;
    fig_height = 100;
    line_width = 2;

  case 'accelerate_decelerate_kph'
    t_end = 400;
    inputSignals.VehSpdRef = timetable([0 0 120 120 0 0]', 'RowTimes',seconds([0 10 150 250 350 t_end])');
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputBusElem(1) = Simulink.BusElement;
    inputBusElem(1).Name = 'VehSpdRef';
    inputBusElem(1).Unit = 'km/hr';
    fig_width = 400;
    fig_height = 200;
    line_width = 2;

  case 'accelerate_decelerate_mph'
    useKph = false;
    t_end = 400;
    inputSignals.VehSpdRef = timetable([0 0 70 70 0 0]', 'RowTimes',seconds([0 10 150 250 350 t_end])');
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'mph'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputBusElem(1) = Simulink.BusElement;
    inputBusElem(1).Name = 'VehSpdRef';
    inputBusElem(1).Unit = 'mph';
    fig_width = 400;
    fig_height = 200;
    line_width = 2;

  case 'simple_drive_pattern'
    t_end = 200;
    inputSignals.VehSpdRef = ...
                timetable([0  0 30 30 40 40 20 20  0  0 30 30 70 70  50  50  30  30   0     0]', ...
       'RowTimes',seconds([0 10 15 20 25 30 35 40 45 50 55 65 70 90 110 120 130 150 190 t_end])');
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputBusElem(1) = Simulink.BusElement;
    inputBusElem(1).Name = 'VehSpdRef';
    inputBusElem(1).Unit = 'km/hr';
    fig_width = 400;
    fig_height = 200;
    line_width = 2;

  case 'ftp75_mph'
    useFromWorkspace = false;
    useKph = false;
    t_end = 2474;
    do_plot = false;  % Plot is turned off.
    % dummy:
    inputSignals.VehSpdRef = inputPatternConst(0);
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputBusElem(1) = Simulink.BusElement;
    inputBusElem(1).Name = 'VehSpdRef';

end

inputBus = Simulink.Bus;
inputBus.Elements = inputBusElem;

if do_plot
  syncedInputs = synchronize( ...
    inputSignals.VehSpdRef );
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.LineWidth = line_width;
  stk.GridVisible = 'on';
  parent.Position(3:4) = [fig_width fig_height];

end  % function
