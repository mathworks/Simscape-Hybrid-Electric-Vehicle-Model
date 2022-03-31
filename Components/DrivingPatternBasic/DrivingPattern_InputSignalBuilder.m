classdef DrivingPattern_InputSignalBuilder < handle
%% Class implementation of input signal builder for driving patterns

% Copyright 2021-2022 The MathWorks, Inc.

%{
DrivingPattern_InputSignalBuilder("Plot_tf",true).Constant;
%}
%{
DrivingPattern_InputSignalBuilder("Plot_tf",true).ThreeStepSpeed;
%}

%{
builder = DrivingPattern_InputSignalBuilder;
builder.Plot_tf = true;
builder.SavePlot_tf = true;
% x = ConstantInput(builder);
% x = TwoStepSpeed(builder);
% x = ThreeStepSpeed(builder);
x = TwoPeakDrivePattern(builder);
%}

properties
  % ## Signals

  VehSpdRef timetable
  VehAccRef timetable

  % ## Other properties

  % Used to compute acceleration from speed.
  dt (1,1) duration = milliseconds(1)

  FunctionName (1,1) string
  StopTime (1,1) duration

  ParentFigure (1,1)  % must be of type matlab.ui.Figure
  Plot_tf (1,1) logical = false
  VisiblePlot_tf (1,1) logical = true
  FigureWidth (1,1) double = 600
  FigureHeight (1,1) double = 400
  LineWidth (1,1) double = 2

  SavePlot_tf (1,1) logical = false
  SavePlotImageFileName (1,1) {mustBeTextScalar} = "image_input_signals.png"
end

methods

  function inpObj = DrivingPattern_InputSignalBuilder(nvpairs)
  %%
    arguments
      nvpairs.Plot_tf
      nvpairs.FigureWidth
      nvpairs.FigureHeight
      nvpairs.LineWidth
    end
    if isfield(nvpairs, 'Plot_tf'), inpObj.Plot_tf = nvpairs.Plot_tf; end
    if isfield(nvpairs, 'FigureWidth'), inpObj.FigureWidth = nvpairs.FigureWidth; end
    if isfield(nvpairs, 'FigureHeight'), inpObj.FigureHeight = nvpairs.FigureHeight; end
    if isfield(nvpairs, 'LineWidth'), inpObj.LineWidth = nvpairs.LineWidth; end

    % Default signals are created in the constructor so that
    % the plotSignals function works right after creating a class object.
    Constant(inpObj);

  end

  function plotSignals(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.ParentFigure (1,1) matlab.ui.Figure
    end

    syncedInputs = synchronize( ...
      inpObj.VehSpdRef, ...
      inpObj.VehAccRef );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.VehSpdRef)
      addUnitString(inpObj.VehAccRef) };

    if not(inpObj.VisiblePlot_tf)
      % Invisible figure.
      inpObj.ParentFigure = figure(Visible = 'off');
    elseif isfield(nvpairs, 'ParentFigure')
      % This function's ParentFigure option is specified.
      inpObj.ParentFigure = nvpairs.ParentFigure;
    else
      % Create a new figure.
      inpObj.ParentFigure = figure;  % Do not use Visible='on'
    end

    stk = stackedplot( inpObj.ParentFigure, syncedInputs );
    stk.LineWidth = inpObj.LineWidth;
    stk.GridVisible = 'on';
    stk.DisplayLabels = dispLbl;
    % stackedplot does not have Interpreter=off setting for the title.
    % To prevent '_' from being interpreted as a subscript directive,
    % replace it with a space.
    % Note that title() does not work with stackedplot either.
    stk.Title = strrep(inpObj.FunctionName, '_', ' ');

    % Making the figure taller than the default plot window height can
    % make the top part of the window go outside the monitor screen.
    % To prevent it, lower the x position of the window,
    % assuming that lowering the window position is safer
    % because the visibility of the window top is more important
    % that of the window bottom.
    pos = inpObj.ParentFigure.Position;
    h_orig = pos(4);
    w = inpObj.FigureWidth;
    h_new = inpObj.FigureHeight;
    inpObj.ParentFigure.Position = [pos(1), pos(2)-(h_new-h_orig), w, h_new];

    if inpObj.SavePlot_tf
      exportgraphics(gca, inpObj.SavePlotImageFileName)
    end  % if
  end  % function

  %% Patterns

  function signalData = Constant(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(1)
      nvpairs.VehSpdRef_Const_kph (1,1) double {mustBeNonnegative} = 0
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.VehSpdRef_Const_kph;
    BuildSignal_VehSpdRef(inpObj, Data=[x1 x1], Time=seconds([0 t_end]));

    BuildSignal_VehAccRef(inpObj, Data=[0 0], Time=seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = TwoStepSpeed(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.VehSpdRef_1_kph (1,1) double {mustBeNonnegative} = 0
      nvpairs.VehSpdRef_2_kph (1,1) double {mustBeNonnegative} = 100
      nvpairs.VehSpdRef_ChangeStartTime (1,1) duration = seconds(10)
      nvpairs.VehSpdRef_ChangeEndTime (1,1) duration = seconds(10+20)
      nvpairs.StopTime (1,1) duration = seconds(30+70)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.VehSpdRef_1_kph;
    x2 = nvpairs.VehSpdRef_2_kph;
    t1 = seconds(nvpairs.VehSpdRef_ChangeStartTime);
    t2 = seconds(nvpairs.VehSpdRef_ChangeEndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t_end )
    BuildSignal_VehSpdRef(inpObj, Data=[x1 x1 x1 x2 x2 x2], Time=seconds([0 0.01 t1 t2 t2+0.01 t_end]));

    delta_t = seconds(inpObj.dt);
    tmp = diff(inpObj.VehSpdRef.VehSpdRef)/delta_t * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    BuildSignal_VehAccRef(inpObj, Data=[tmp; tmp(end)], Time=inpObj.VehSpdRef.Time);

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = ThreeStepSpeed(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.VehSpdRef_1_kph (1,1) double {mustBeNonnegative} = 0
      nvpairs.VehSpdRef_2_kph (1,1) double {mustBeNonnegative} = 100
      nvpairs.VehSpdRef_3_kph (1,1) double {mustBeNonnegative} = 0
      nvpairs.VehSpdRef_1to2_ChangeStartTime (1,1) duration = seconds(10)
      nvpairs.VehSpdRef_1to2_ChangeEndTime (1,1) duration = seconds(10+20)
      nvpairs.VehSpdRef_2to3_ChangeStartTime (1,1) duration = seconds(30+50)
      nvpairs.VehSpdRef_2to3_ChangeEndTime (1,1) duration = seconds(80+10)
      nvpairs.StopTime (1,1) duration = seconds(90+10)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.VehSpdRef_1_kph;
    x2 = nvpairs.VehSpdRef_2_kph;
    x3 = nvpairs.VehSpdRef_3_kph;
    t1 = seconds(nvpairs.VehSpdRef_1to2_ChangeStartTime);
    t2 = seconds(nvpairs.VehSpdRef_1to2_ChangeEndTime);
    t3 = seconds(nvpairs.VehSpdRef_2to3_ChangeStartTime);
    t4 = seconds(nvpairs.VehSpdRef_2to3_ChangeEndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t_end )
    BuildSignal_VehSpdRef(inpObj, ...
                Data=[x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
        Time=seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    delta_t = seconds(inpObj.dt);
    tmp = diff(inpObj.VehSpdRef.VehSpdRef)/delta_t * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    BuildSignal_VehAccRef(inpObj, Data=[tmp; tmp(end)], Time=inpObj.VehSpdRef.Time);

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = TwoPeakDrivePattern(inpObj, nvpairs)
  %%
    arguments
      inpObj

      % Up
      nvpairs.VehSpdRef_1_ChangeStartTime (1,1) duration = seconds(10)
      nvpairs.VehSpdRef_1_ChangeEndTime (1,1) duration = seconds(10+10)

      nvpairs.VehSpdRef_1_kph (1,1) double {mustBeNonnegative} = 30

      % Down
      nvpairs.VehSpdRef_2_ChangeStartTime (1,1) duration = seconds(20+120)
      nvpairs.VehSpdRef_2_ChangeEndTime (1,1) duration = seconds(140+10)

      % Up
      nvpairs.VehSpdRef_3_ChangeStartTime (1,1) duration = seconds(150+60)
      nvpairs.VehSpdRef_3_ChangeEndTime (1,1) duration = seconds(210+10)

      nvpairs.VehSpdRef_2_kph (1,1) double {mustBeNonnegative} = 40

      % Up
      nvpairs.VehSpdRef_4_ChangeStartTime (1,1) duration = seconds(220+60)
      nvpairs.VehSpdRef_4_ChangeEndTime (1,1) duration = seconds(280+20)

      nvpairs.VehSpdRef_3_kph (1,1) double {mustBeNonnegative} = 100

      % Down
      nvpairs.VehSpdRef_5_ChangeStartTime (1,1) duration = seconds(300+180)
      nvpairs.VehSpdRef_5_ChangeEndTime (1,1) duration = seconds(480+30)

      nvpairs.StopTime (1,1) duration = seconds(510+90)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.VehSpdRef_1_kph;
    x2 = nvpairs.VehSpdRef_2_kph;
    x3 = nvpairs.VehSpdRef_3_kph;
    t1 = seconds(nvpairs.VehSpdRef_1_ChangeStartTime);
    t2 = seconds(nvpairs.VehSpdRef_1_ChangeEndTime);
    t3 = seconds(nvpairs.VehSpdRef_2_ChangeStartTime);
    t4 = seconds(nvpairs.VehSpdRef_2_ChangeEndTime);
    t5 = seconds(nvpairs.VehSpdRef_3_ChangeStartTime);
    t6 = seconds(nvpairs.VehSpdRef_3_ChangeEndTime);
    t7 = seconds(nvpairs.VehSpdRef_4_ChangeStartTime);
    t8 = seconds(nvpairs.VehSpdRef_4_ChangeEndTime);
    t9 = seconds(nvpairs.VehSpdRef_5_ChangeStartTime);
    t10 = seconds(nvpairs.VehSpdRef_5_ChangeEndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t5 )
    assert( t5 < t6 )
    assert( t6+0.01 < t7 )
    assert( t7 < t8 )
    assert( t8+0.01 < t9 )
    assert( t9 < t10 )
    assert( t10+0.01 < t_end )
    BuildSignal_VehSpdRef(inpObj, ...
Data =         [0 0    0  x1 x1      x1 0  0       0  x2 x2      x2 x3 x3      x3 0  0         0], ...
Time = seconds([0 0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t5 t6 t6+0.01 t7 t8 t8+0.01 t9 t10 t10+0.01 t_end]));

    delta_t = seconds(inpObj.dt);
    tmp = diff(inpObj.VehSpdRef.VehSpdRef)/delta_t * 1000/3600;  % (km/hr)/s to m/s^2 conversion
    BuildSignal_VehAccRef(inpObj, Data=[tmp; tmp(end)], Time=inpObj.VehSpdRef.Time);

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

end  % methods

methods (Access = private)

  %% Build signal trace with timetable

  function inpObj = BuildSignal_VehSpdRef(inpObj, nvpairs)
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.Interpolate (1,1) logical = true
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.VehSpdRef = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.VehSpdRef.Properties.VariableNames = {'VehSpdRef'};
    inpObj.VehSpdRef.Properties.VariableUnits = {'km/hr'};
    inpObj.VehSpdRef.Properties.VariableContinuity = {'continuous'};
    if nvpairs.Interpolate
      inpObj.VehSpdRef = ...
        retime(inpObj.VehSpdRef, regular='makima', TimeStep=nvpairs.TimeStep);
      % Replace negative values with 0.
      inpObj.VehSpdRef.VehSpdRef(inpObj.VehSpdRef.VehSpdRef < 0) = 0;
    end
  end

  function inpObj = BuildSignal_VehAccRef(inpObj, nvpairs)
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.Interpolate (1,1) logical = true
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.VehAccRef = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.VehAccRef.Properties.VariableNames = {'VehAccRef'};
    inpObj.VehAccRef.Properties.VariableUnits = {'m/s^2'};
    inpObj.VehAccRef.Properties.VariableContinuity = {'continuous'};
    if nvpairs.Interpolate
      inpObj.VehAccRef = ...
        retime(inpObj.VehAccRef, regular='makima', TimeStep=nvpairs.TimeStep);
    end
  end

  function signalData = BundleSignals(inpObj)
  %%
    signalData.Signals.VehSpdRef = inpObj.VehSpdRef;
    signalData.Signals.VehAccRef = inpObj.VehAccRef;

    signalData.Bus = Simulink.Bus;
    sigs = { ...
      inpObj.VehSpdRef
      inpObj.VehAccRef };
    for i = 1:numel(sigs)
      signalData.Bus.Elements(i) = Simulink.BusElement;
      signalData.Bus.Elements(i).Name = sigs{i}.Properties.VariableNames{1};
      signalData.Bus.Elements(i).Unit = sigs{i}.Properties.VariableUnits{1};
    end

    % Additional data to return
    opts.FunctionName = inpObj.FunctionName;
    opts.StopTime_s = seconds(inpObj.StopTime);
    opts.TimeStamp = string(datetime("now", Format="yyyy-MM-dd HH:mm:ss"));
    opts.ParentFigure = inpObj.ParentFigure;

    signalData.Options = opts;
  end  % function

end  % methods
end  % classdef
