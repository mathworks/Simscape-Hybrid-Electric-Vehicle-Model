function [inputSignals, inputBus, initial, opt] = DrivingPatternBasic_inputs(nvpairs)
%% Driving Pattern Input Signals

% Copyright 2021 The MathWorks, Inc.

arguments
  nvpairs.InputPattern (1,1) {mustBeMember(nvpairs.InputPattern, {...
      'all_zero' ...
      'mg2_accelerate' ...
      'eng_accelerate' ...
      'high_speed' ...
      'standstill_charge' ...
      'accelerate_decelerate_kph' ...
      'accelerate_decelerate_mph' ...
      'simple_drive_pattern' ...
      'simple_slow_drive_pattern' ...
      'ftp75_mph' ...
    })} = 'all_zero'
  nvpairs.TimeStep (1,1) double {mustBePositive} = 0.1
  nvpairs.PlotParent (1,1) matlab.ui.Figure
  nvpairs.PlotSpeedOnly (1,1) matlab.lang.OnOffSwitchState = true
end

input_pattern = nvpairs.InputPattern;
dt = nvpairs.TimeStep;

do_plot = false;
if isfield(nvpairs, 'PlotParent')
  do_plot = true;
  parent = nvpairs.PlotParent;
  plot_speed_only = nvpairs.PlotSpeedOnly;
  opt.fig_width = 400;
  opt.fig_height = 200;
  opt.line_width = 2;
end

% false when using other sources such as Drive Cycle Source block in PTBS
opt.useFromWorkspace = true;

% true for km/hr, false for mi/hr
opt.useKph = true;

% Default value for initial SOC
initial.HVBattery_SOC_pct = 75;

inputPatternConst = @(c) timetable([c c]', 'RowTimes',seconds([0 1])');

inputBus = Simulink.Bus;
switch input_pattern
  case 'all_zero'
    t_end = 1;
    inputSignals.VehSpdRef = inputPatternConst(0);
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = inputPatternConst(0);
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';
    opt.fig_width = 200;
    opt.fig_height = 100;

  case 'high_speed'
    t_end = 5000;
    % Define signal trace:
    VehSpdRef = timetable([0 0 0      100 100 100]',...
       'RowTimes',seconds([0 9.5 10   60 60.5 t_end])');
    % Make the signal trace smooth using Akima interpolation:
    VehSpdRef = retime(VehSpdRef, 'regular','makima', 'TimeStep',seconds(dt));
    % Remove the negative wiggle:
    VehSpdRef.Var1(VehSpdRef.Var1 < 0) = 0;
    % Calculate the acceleration:
    tmp = diff(VehSpdRef.Var1)/dt * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    VehAccRef = timetable([tmp; tmp(end)], 'RowTimes',VehSpdRef.Time);
    inputSignals.VehSpdRef = VehSpdRef;
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = VehAccRef;
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

  case 'standstill_charge'
    initial.HVBattery_SOC_pct = 20;  % start from low SOC
    t_end = 4000;
    inputSignals.VehSpdRef = inputPatternConst(0);
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = inputPatternConst(0);
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';
    opt.fig_width = 300;
    opt.fig_height = 100;

  case 'mg2_accelerate'
    initial.HVBattery_SOC_pct = 95;  % start from high SOC
    t_end = 5;
    % Define signal trace:
    VehSpdRef = timetable([0 0 0     40 40 40]',...
       'RowTimes',seconds([0 0.5 1   3 3.5 t_end])');
    % Make the signal trace smooth using Akima interpolation:
    VehSpdRef = retime(VehSpdRef, 'regular','makima', 'TimeStep',seconds(dt)');
    % Remove the negative wiggle:
    VehSpdRef.Var1(VehSpdRef.Var1 < 0) = 0;
    % Calculate the acceleration:
    tmp = diff(VehSpdRef.Var1)/dt * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    VehAccRef = timetable([tmp; tmp(end)], 'RowTimes',VehSpdRef.Time);
    inputSignals.VehSpdRef = VehSpdRef;
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = VehAccRef;
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

  case 'eng_accelerate'
    initial.HVBattery_SOC_pct = 30;  % start from low SOC
    t_end = 200;
    % Define signal trace:
    VehSpdRef = timetable([0 0 0      30 30 30]',...
       'RowTimes',seconds([0 9.5 10   40 40.5 t_end])');
    % Make the signal trace smooth using Akima interpolation:
    VehSpdRef = retime(VehSpdRef, 'regular','makima', 'TimeStep',seconds(dt));
    % Remove the negative wiggle:
    VehSpdRef.Var1(VehSpdRef.Var1 < 0) = 0;
    % Calculate the acceleration:
    tmp = diff(VehSpdRef.Var1)/dt * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    VehAccRef = timetable([tmp; tmp(end)], 'RowTimes',VehSpdRef.Time);
    inputSignals.VehSpdRef = VehSpdRef;
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = VehAccRef;
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

  case 'accelerate_decelerate_kph'
    t_end = 400;
    % Define signal trace:
    VehSpdRef = timetable([0 0 0      120 120   120 120     0 0 0]',...
       'RowTimes',seconds([0 9.5 10   150 150.5 249.5 250   350 350.5 t_end])');
    % Make the signal trace smooth using Akima interpolation:
    VehSpdRef = retime(VehSpdRef, 'regular','makima', 'TimeStep',seconds(dt));
    % Remove the negative wiggle:
    VehSpdRef.Var1(VehSpdRef.Var1 < 0) = 0;
    % Calculate the acceleration:
    tmp = diff(VehSpdRef.Var1)/dt * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    VehAccRef = timetable([tmp; tmp(end)], 'RowTimes',VehSpdRef.Time);
    inputSignals.VehSpdRef = VehSpdRef;
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = VehAccRef;
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

  case 'accelerate_decelerate_mph'
    opt.useKph = false;
    t_end = 400;
    % Define signal trace:
    VehSpdRef = timetable([0 0 0      70 70     70 70       0 0 0]',...
       'RowTimes',seconds([0 9.5 10   150 150.5 249.5 250   350 350.5 t_end])');
    % Make the signal trace smooth using Akima interpolation:
    VehSpdRef = retime(VehSpdRef, 'regular','makima', 'TimeStep',seconds(dt));
    % Remove the negative wiggle:
    VehSpdRef.Var1(VehSpdRef.Var1 < 0) = 0;
    % Calculate the acceleration:
    tmp = diff(VehSpdRef.Var1)/dt * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    VehAccRef = timetable([tmp; tmp(end)], 'RowTimes',VehSpdRef.Time);
    inputSignals.VehSpdRef = VehSpdRef;
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'mph'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = VehAccRef;
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'mph';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

  case 'simple_drive_pattern'
    t_end = 200;
    % Define signal trace:
    VehSpdRef = timetable([0 0 0      30 30   30 30     40 40   40 40     20 20   20 20      0 0       0  0   45 45 45     55 55 55     95 95   95 95      70 70     70 70       30 30     30 30        0 0     0]', ...
       'RowTimes',seconds([0 9.5 10   15 15.5 19.5 20   25 25.5 29.5 30   35 35.5 39.5 40   45 45.5 49.5 50   58 58.5 59   65 65.5 66   85 85.5 89.5 90   110 110.5 119.5 120   150 150.5 159.5 160   190 190.5 t_end])');
    % Make the signal trace smooth using Akima interpolation:
    VehSpdRef = retime(VehSpdRef, 'regular','makima', 'TimeStep',seconds(dt));
    % Remove the negative wiggle:
    VehSpdRef.Var1(VehSpdRef.Var1 < 0) = 0;
    % Calculate the acceleration:
    tmp = diff(VehSpdRef.Var1)/dt * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    VehAccRef = timetable([tmp; tmp(end)], 'RowTimes',VehSpdRef.Time);
    inputSignals.VehSpdRef = VehSpdRef;                
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = VehAccRef;
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

  case 'simple_slow_drive_pattern'
    t_end = 200;
    % Define signal trace:
    VehSpdRef = timetable([0 0 0      20 20   20 20     30 30   30 30     10 10   10 10      0 0       0  0   25 25 25     35 35 35     45 45   45 45      30 30     30 30       15 15     15 15        0 0     0]', ...
       'RowTimes',seconds([0 9.5 10   15 15.5 19.5 20   25 25.5 29.5 30   35 35.5 39.5 40   45 45.5 49.5 50   58 58.5 59   65 65.5 66   85 85.5 89.5 90   110 110.5 119.5 120   150 150.5 159.5 160   190 190.5 t_end])');
    % Make the signal trace smooth using Akima interpolation:
    VehSpdRef = retime(VehSpdRef, 'regular','makima', 'TimeStep',seconds(dt));
    % Remove the negative wiggle:
    VehSpdRef.Var1(VehSpdRef.Var1 < 0) = 0;
    % Calculate the acceleration:
    tmp = diff(VehSpdRef.Var1)/dt * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    VehAccRef = timetable([tmp; tmp(end)], 'RowTimes',VehSpdRef.Time);
    inputSignals.VehSpdRef = VehSpdRef;                
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inputSignals.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    inputSignals.VehAccRef = VehAccRef;
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputSignals.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inputSignals.VehAccRef.Properties.VariableContinuity = {'continuous'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'km/hr';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

  case 'ftp75_mph'
    opt.useFromWorkspace = false;  % Use another source
    opt.useKph = false;
    t_end = 2474;  % Adjust this with another source
    do_plot = false;  % Plot is turned off.
    % dummy:
    inputSignals.VehSpdRef = inputPatternConst(0);
    inputSignals.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inputSignals.VehAccRef = inputPatternConst(0);
    inputSignals.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inputBus.Elements(1) = Simulink.BusElement;
    inputBus.Elements(1).Name = 'VehSpdRef';
    inputBus.Elements(1).Unit = 'mph';
    inputBus.Elements(2) = Simulink.BusElement;
    inputBus.Elements(2).Name = 'VehAccRef';
    inputBus.Elements(2).Unit = 'm/s^2';

end

opt.t_end = t_end;

if do_plot
  if plot_speed_only
    syncedInputs = synchronize( ...
      inputSignals.VehSpdRef );
  else
    syncedInputs = synchronize( ...
      inputSignals.VehSpdRef, ...
      inputSignals.VehAccRef );
  end
  stk = stackedplot( parent, syncedInputs, 'LineWidth',2 );
  stk.LineWidth = opt.line_width;
  stk.GridVisible = 'on';
end

end  % function
