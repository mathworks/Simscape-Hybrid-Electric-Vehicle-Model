classdef DrivePattern_InputSignalBuilder < handle
%% Class implementation of input signal builder for driving patterns

% Copyright 2021-2022 The MathWorks, Inc.

properties
  % ## Signals

  VehSpd timetable
  VehAcc timetable

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

  function inpObj = DrivePattern_InputSignalBuilder(nvpairs)
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
    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;
    Constant(inpObj);
    inpObj.Plot_tf = tmp;

  end

  function signalData = Constant(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(1)
      nvpairs.VehSpd_Const (1,1) double {mustBeNonnegative} = 0
      nvpairs.VehSpdUnit {mustBeMember(nvpairs.VehSpdUnit, {'m/s', 'km/hr', 'mph'})} = "m/s"
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    unitStr = nvpairs.VehSpdUnit;

    x1 = nvpairs.VehSpd_Const;
    BuildSignal_VehSpd(inpObj, unitStr, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = Accelerate_Decelerate(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Acceleration_StartTime = seconds(10)
      nvpairs.Acceleration_EndTime = seconds(10 + 30)
      nvpairs.PeakSpeed = 100
      nvpairs.VehSpdUnit {mustBeMember(nvpairs.VehSpdUnit, {'m/s', 'km/hr', 'mph'})} = "km/hr"
      nvpairs.Deceleration_StartTime = seconds(40 + 90)
      nvpairs.Deceleration_EndTime = seconds(130 + 60)
      nvpairs.StopTime (1,1) duration = seconds(190 + 10)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3(inpObj, ...
      "VehSpdUnit", nvpairs.VehSpdUnit, ...
      "VehSpd_1", 0, ...
      "VehSpd_2", nvpairs.PeakSpeed, ...
      "VehSpd_3", 0, ...
      "VehSpd_1to2_ChangeStartTime", nvpairs.Acceleration_StartTime, ...
      "VehSpd_1to2_ChangeEndTime",   nvpairs.Acceleration_EndTime, ...
      "VehSpd_2to3_ChangeStartTime", nvpairs.Deceleration_StartTime, ...
      "VehSpd_2to3_ChangeEndTime",   nvpairs.Deceleration_EndTime, ...
      "StopTime", nvpairs.StopTime );

    inpObj.Plot_tf = tmp;

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = Accelerate_Decelerate_Twice(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.VehSpdUnit {mustBeMember(nvpairs.VehSpdUnit, {'m/s', 'km/hr', 'mph'})} = "km/hr"

      nvpairs.Acceleration_1_StartTime = seconds(10)
      nvpairs.Acceleration_1_EndTime = seconds(10 + 10)
      nvpairs.PeakSpeed_1 = 40
      nvpairs.Deceleration_1_StartTime = seconds(20 + 60)
      nvpairs.Deceleration_1_EndTime = seconds(80 + 20)

      nvpairs.Acceleration_2_StartTime = seconds(100 + 30)
      nvpairs.Acceleration_2_EndTime = seconds(130 + 30)
      nvpairs.PeakSpeed_2 = 120
      nvpairs.Deceleration_2_StartTime = seconds(160 + 60)
      nvpairs.Deceleration_2_EndTime = seconds(220 + 60)

      nvpairs.StopTime (1,1) duration = seconds(280 + 20)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step5(inpObj, ...
      "VehSpdUnit", nvpairs.VehSpdUnit, ...
      "VehSpd_1", 0, ...
      "VehSpd_2", nvpairs.PeakSpeed_1, ...
      "VehSpd_3", 0, ...
      "VehSpd_4", nvpairs.PeakSpeed_2, ...
      "VehSpd_5", 0, ...
      "VehSpd_1_ChangeStartTime", nvpairs.Acceleration_1_StartTime, ...
      "VehSpd_1_ChangeEndTime",   nvpairs.Acceleration_1_EndTime, ...
      "VehSpd_2_ChangeStartTime", nvpairs.Deceleration_1_StartTime, ...
      "VehSpd_2_ChangeEndTime",   nvpairs.Deceleration_1_EndTime, ...
      "VehSpd_3_ChangeStartTime", nvpairs.Acceleration_2_StartTime, ...
      "VehSpd_3_ChangeEndTime",   nvpairs.Acceleration_2_EndTime, ...
      "VehSpd_4_ChangeStartTime", nvpairs.Deceleration_2_StartTime, ...
      "VehSpd_4_ChangeEndTime",   nvpairs.Deceleration_2_EndTime, ...
      "StopTime", nvpairs.StopTime );

    inpObj.Plot_tf = tmp;

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = SimpleDrivePattern(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(200)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    BuildSignal_VehSpd(inpObj, 'km/hr', ...
      'Data',        [0 0   0    30 30   30   30   40 40   40   40   20 20   20   20    0  0    0   0    45 45 45     55 55 55     95 95   95   95    70  70    70    70    30  30    30    30     0   0   0    ], ...
      'Time',seconds([0 9.5 10   15 15.5 19.5 20   25 25.5 29.5 30   35 35.5 39.5 40   45 45.5 49.5 50   58 58.5 59   65 65.5 66   85 85.5 89.5 90   110 110.5 119.5 120   150 150.5 159.5 160   190 190.5 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = FTP75(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(2474)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    % Data is dummy. Build Signal is still necessary to build
    % a struct for signals and a Bus object.
    BuildSignal_VehSpd(inpObj, 'Data',[0 0], 'Time',seconds([0 t_end]));

%     if inpObj.Plot_tf
%       plotSignals(inpObj);
%     end

    signalData = BundleSignals(inpObj);

    % This function does not define signals, thus From Workspace block isnot used.
    signalData.Options.useFromWorkspace = false;

  end  % function

  function signalData = Step3(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.VehSpdUnit {mustBeMember(nvpairs.VehSpdUnit, {'m/s', 'km/hr', 'mph'})} = "km/hr"
      nvpairs.VehSpd_1 (1,1) double {mustBeNonnegative} = 0
      nvpairs.VehSpd_2 (1,1) double {mustBeNonnegative} = 100
      nvpairs.VehSpd_3 (1,1) double {mustBeNonnegative} = 0
      nvpairs.VehSpd_1to2_ChangeStartTime (1,1) duration = seconds(10)
      nvpairs.VehSpd_1to2_ChangeEndTime (1,1) duration = seconds(10+30)
      nvpairs.VehSpd_2to3_ChangeStartTime (1,1) duration = seconds(40+20)
      nvpairs.VehSpd_2to3_ChangeEndTime (1,1) duration = seconds(60+30)
      nvpairs.StopTime (1,1) duration = seconds(90+10)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    unitStr = nvpairs.VehSpdUnit;

    x1 = nvpairs.VehSpd_1;
    x2 = nvpairs.VehSpd_2;
    x3 = nvpairs.VehSpd_3;
    t1 = seconds(nvpairs.VehSpd_1to2_ChangeStartTime);
    t2 = seconds(nvpairs.VehSpd_1to2_ChangeEndTime);
    t3 = seconds(nvpairs.VehSpd_2to3_ChangeStartTime);
    t4 = seconds(nvpairs.VehSpd_2to3_ChangeEndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t_end )
    BuildSignal_VehSpd(inpObj, unitStr, ...
      'Data',         [x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
      'Time', seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = Step5(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.VehSpdUnit {mustBeMember(nvpairs.VehSpdUnit, {'m/s', 'km/hr', 'mph'})} = "km/hr"

      nvpairs.VehSpd_1 (1,1) double {mustBeNonnegative} = 10
      nvpairs.VehSpd_2 (1,1) double {mustBeNonnegative} = 20
      nvpairs.VehSpd_3 (1,1) double {mustBeNonnegative} = 30
      nvpairs.VehSpd_4 (1,1) double {mustBeNonnegative} = 40
      nvpairs.VehSpd_5 (1,1) double {mustBeNonnegative} = 50

      nvpairs.VehSpd_1_ChangeStartTime (1,1) duration = seconds(30)
      nvpairs.VehSpd_1_ChangeEndTime (1,1) duration = seconds(30 + 10)

      nvpairs.VehSpd_2_ChangeStartTime (1,1) duration = seconds(40 + 30)
      nvpairs.VehSpd_2_ChangeEndTime (1,1) duration = seconds(70 + 10)

      nvpairs.VehSpd_3_ChangeStartTime (1,1) duration = seconds(80 + 30)
      nvpairs.VehSpd_3_ChangeEndTime (1,1) duration = seconds(110 + 10)

      nvpairs.VehSpd_4_ChangeStartTime (1,1) duration = seconds(120 + 30)
      nvpairs.VehSpd_4_ChangeEndTime (1,1) duration = seconds(150 + 10)

      nvpairs.StopTime (1,1) duration = seconds(160 + 40)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    unitStr = nvpairs.VehSpdUnit;

    x1 = nvpairs.VehSpd_1;
    x2 = nvpairs.VehSpd_2;
    x3 = nvpairs.VehSpd_3;
    x4 = nvpairs.VehSpd_4;
    x5 = nvpairs.VehSpd_5;
    t1 = seconds(nvpairs.VehSpd_1_ChangeStartTime);
    t2 = seconds(nvpairs.VehSpd_1_ChangeEndTime);
    t3 = seconds(nvpairs.VehSpd_2_ChangeStartTime);
    t4 = seconds(nvpairs.VehSpd_2_ChangeEndTime);
    t5 = seconds(nvpairs.VehSpd_3_ChangeStartTime);
    t6 = seconds(nvpairs.VehSpd_3_ChangeEndTime);
    t7 = seconds(nvpairs.VehSpd_4_ChangeStartTime);
    t8 = seconds(nvpairs.VehSpd_4_ChangeEndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t5 )
    assert( t5 < t6 )
    assert( t6+0.01 < t7 )
    assert( t7 < t8 )
    assert( t8+0.01 < t_end )
    BuildSignal_VehSpd(inpObj, unitStr, ...
      'Data',         [x1 x1   x1 x2 x2      x2 x3 x3      x3 x4 x4      x4 x5 x5      x5], ...
      'Time', seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t5 t6 t6+0.01 t7 t8 t8+0.01 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function plotSignals(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.ParentFigure (1,1) matlab.ui.Figure
    end

    syncedInputs = synchronize( ...
      inpObj.VehSpd, ...
      inpObj.VehAcc );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.VehSpd)
      addUnitString(inpObj.VehAcc) };

    if not(inpObj.VisiblePlot_tf)
      % Invisible figure.
      inpObj.ParentFigure = figure('Visible', 'off');
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

end  % methods

methods (Access = private)

  %% Build signal trace with timetable

  function inpObj = BuildSignal_VehSpd(inpObj, unitStr, nvpairs)
    arguments
      inpObj
      unitStr {mustBeMember(unitStr, {'m/s', 'km/hr', 'mph'})} = "m/s"
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.Interpolate (1,1) logical = true
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end

    % ### Speed

    inpObj.VehSpd = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.VehSpd.Properties.VariableNames = {'VehSpd'};
    inpObj.VehSpd.Properties.VariableUnits = {char(unitStr)};
    inpObj.VehSpd.Properties.VariableContinuity = {'continuous'};
    if nvpairs.Interpolate
      inpObj.VehSpd = ...
        retime(inpObj.VehSpd, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
      % Replace negative values with 0.
      inpObj.VehSpd.VehSpd(inpObj.VehSpd.VehSpd < 0) = 0;
    end

    % ### Compute acceleration from speed
    % 'm/s^2' is always used for the unit of acceleration.

    unitConversionFactor = 1;
    switch unitStr
    case 'km/hr'
      % km/hr to m/s
      unitConversionFactor = 10/36;
    case 'mhp'
      % mi/hr to m/s
      unitConversionFactor = 1609.344/3600;
    end

    delta_t = seconds(inpObj.dt);
    tmpAcc = diff(inpObj.VehSpd.VehSpd)/delta_t * unitConversionFactor;

    inpObj.VehAcc = timetable([tmpAcc; tmpAcc(end)], 'RowTimes',inpObj.VehSpd.Time);
    inpObj.VehAcc.Properties.VariableNames = {'VehAcc'};
    inpObj.VehAcc.Properties.VariableUnits = {'m/s^2'};
    inpObj.VehAcc.Properties.VariableContinuity = {'continuous'};
  end

  function signalData = BundleSignals(inpObj)
  %%
    signalData.Signals.VehSpd = inpObj.VehSpd;
    signalData.Signals.VehAcc = inpObj.VehAcc;

    signalData.Bus = Simulink.Bus;
    sigs = { ...
      inpObj.VehSpd
      inpObj.VehAcc };
    for i = 1:numel(sigs)
      signalData.Bus.Elements(i) = Simulink.BusElement;
      signalData.Bus.Elements(i).Name = sigs{i}.Properties.VariableNames{1};
      signalData.Bus.Elements(i).Unit = sigs{i}.Properties.VariableUnits{1};
    end

    % Additional data to return
    opts.FunctionName = inpObj.FunctionName;
    opts.StopTime_s = seconds(inpObj.StopTime);
    opts.TimeStamp = string(datetime("now", "Format","yyyy-MM-dd HH:mm:ss"));
    opts.ParentFigure = inpObj.ParentFigure;

    % By default, From Workspace is used as a source of external input signals.
    opts.useFromWorkspace = true;

    signalData.Options = opts;
  end  % function

end  % methods
end  % classdef
