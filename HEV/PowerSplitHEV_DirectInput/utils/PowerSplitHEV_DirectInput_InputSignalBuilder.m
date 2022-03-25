classdef PowerSplitHEV_DirectInput_InputSignalBuilder < handle
% Class implementation of Input Signal Builder

% Copyright 2022 The MathWorks, Inc.

% You can run this class by selecting the following code
% and pressing the F9 key.
%{
hevInputData = PowerSplitHEV_DirectInput_InputSignalBuilder().Constant;
hevDirect_InputSignals = hevInputData.Signals;
hevDirect_InputBus = hevInputData.Bus;
t_end = hevInputData.Options.StopTime_s;
%}

properties
  % ### Signals

  Mg2TrqCmd timetable
  Mg1TrqCmd timetable
  EngTrqCmd timetable
  BrakeForce timetable
  RoadGrade timetable

  % ### Other properties

  FunctionName (1,1) string
  StopTime (1,1) duration

  ParentFigure (1,1)  % must be of type matlab.ui.Figure
  Plot_tf (1,1) logical = false
  VisiblePlot_tf (1,1) logical = true
  FigureWidth (1,1) double = 400
  FigureHeight (1,1) double = 300
  LineWidth (1,1) double = 2

  SavePlot_tf (1,1) logical = false
  SavePlotImageFileName (1,1) {mustBeTextScalar} = "image_input_signals.png"
end

methods

  function inpObj = PowerSplitHEV_DirectInput_InputSignalBuilder(nvpairs)
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

  function plotSignals(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.ParentFigure (1,1)
    end

    syncedInputs = synchronize( ...
                      inpObj.Mg2TrqCmd, ...
                      inpObj.Mg1TrqCmd, ...
                      inpObj.EngTrqCmd, ...
                      inpObj.BrakeForce, ...
                      inpObj.RoadGrade );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.Mg2TrqCmd), ...
      addUnitString(inpObj.Mg1TrqCmd), ...
      addUnitString(inpObj.EngTrqCmd), ...
      addUnitString(inpObj.BrakeForce), ...
      addUnitString(inpObj.RoadGrade) };

    if not(inpObj.VisiblePlot_tf)
      % Invisible figure.
      inpObj.ParentFigure = figure('Visible', 'off');
    elseif isfield(nvpairs, 'ParentFigure')
      % This function's ParentFigure option is specified.
      assert(isa(nvpairs.ParentFigure, 'matlab.ui.Figure'))
      inpObj.ParentFigure = nvpairs.ParentFigure;
    else
      % Create a new figure.
      inpObj.ParentFigure = figure;  % Do not use 'Visible','on'
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

  %% Input Signal Patterns

  function signalData = Constant(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(100)
      nvpairs.MG2TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.EngineTorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.MG2TorqueCommand_Const_Nm;
    BuildSignal_MG2TorqueCommand(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.MG1TorqueCommand_Const_Nm;
    BuildSignal_MG1TorqueCommand(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.EngineTorqueCommand_Const_Nm;
    BuildSignal_EngineTorqueCommand(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.BrakeForce_Const_N;
    BuildSignal_BrakeForce(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.RoadGrade_Const_pct;
    BuildSignal_RoadGrade(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);
  end  % function

%{
  function signalData = Step(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0

      nvpairs.MG2TorqueCommand_1_Nm (1,1) = 20
      nvpairs.MG2TorqueCommand_2_Nm (1,1) = 20

      nvpairs.MG2TrqCmdChange_StartTime (1,1) duration = seconds(1000)
      nvpairs.MG2TrqCmdChange_EndTime (1,1) duration = seconds(1000 + 2)

      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = -5

      nvpairs.MG1TrqCmdChange_StartTime (1,1) duration = seconds(1500)
      nvpairs.MG1TrqCmdChange_EndTime (1,1) duration = seconds(1500 + 2)

      nvpairs.EngineTorqueCommand_1_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.EngineTorqueCommand_2_Nm (1,1) {mustBeNonnegative} = 60

      nvpairs.EngTrqCmdChange_StartTime (1,1) duration = seconds(500)
      nvpairs.EngTrqCmdChange_EndTime (1,1) duration = seconds(500 + 2)

      nvpairs.StopTime (1,1) duration = seconds(2000)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.MG2TorqueCommand_1_Nm;
    x2 = nvpairs.MG2TorqueCommand_2_Nm;
    t1 = seconds(nvpairs.MG2TrqCmdChange_StartTime);
    t2 = seconds(nvpairs.MG2TrqCmdChange_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t_end)
    BuildSignal_MG2TorqueCommand(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t_end]));

    x1 = nvpairs.MG1TorqueCommand_1_Nm;
    x2 = nvpairs.MG1TorqueCommand_2_Nm;
    t1 = seconds(nvpairs.MG1TrqCmdChange_StartTime);
    t2 = seconds(nvpairs.MG1TrqCmdChange_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t_end)
    BuildSignal_MG1TorqueCommand(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t_end]));

    x1 = nvpairs.EngineTorqueCommand_1_Nm;
    x2 = nvpairs.EngineTorqueCommand_2_Nm;
    t1 = seconds(nvpairs.EngTrqCmdChange_StartTime);
    t2 = seconds(nvpairs.EngTrqCmdChange_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t_end)
    BuildSignal_EngineTorqueCommand(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t_end]));

    x1 = nvpairs.BrakeForce_Const_N;
    BuildSignal_BrakeForce(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.RoadGrade_Const_pct;
    BuildSignal_RoadGrade(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);
  end  % function
%}

  function signalData = Step3(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.BrakeForce_1_N (1,1) {mustBeNonnegative} = 6000
      nvpairs.BrakeForce_2_N (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForce_3_N (1,1) {mustBeNonnegative} = 6000
      nvpairs.BrakeForceChange_1_StartTime (1,1) duration = seconds(100)
      nvpairs.BrakeForceChange_1_EndTime (1,1) duration = seconds(100 + 1)
      nvpairs.BrakeForceChange_2_StartTime (1,1) duration = seconds(1900)
      nvpairs.BrakeForceChange_2_EndTime (1,1) duration = seconds(1900 + 50)

      nvpairs.RoadGrade_1_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_1_pct, -50, 50)} = 0
      nvpairs.RoadGrade_2_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_2_pct, -50, 50)} = 5
      nvpairs.RoadGrade_3_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_3_pct, -50, 50)} = 0
      nvpairs.RoadGradeChange_1_StartTime (1,1) duration = seconds(800)
      nvpairs.RoadGradeChange_1_EndTime (1,1) duration = seconds(800 + 10)
      nvpairs.RoadGradeChange_2_StartTime (1,1) duration = seconds(1300)
      nvpairs.RoadGradeChange_2_EndTime (1,1) duration = seconds(1300 + 10)

      nvpairs.MG2TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG2TorqueCommand_2_Nm (1,1) = 30
      nvpairs.MG2TorqueCommand_3_Nm (1,1) = 0
      nvpairs.MG2TrqCmdChange_1_StartTime (1,1) duration = seconds(101)
      nvpairs.MG2TrqCmdChange_1_EndTime (1,1) duration = seconds(101 + 5)
      nvpairs.MG2TrqCmdChange_2_StartTime (1,1) duration = seconds(1900 - 2)
      nvpairs.MG2TrqCmdChange_2_EndTime (1,1) duration = seconds(1898 + 2)

      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_3_Nm (1,1) = 0
      nvpairs.MG1TrqCmdChange_1_StartTime (1,1) duration = seconds(500)
      nvpairs.MG1TrqCmdChange_1_EndTime (1,1) duration = seconds(500 + 2)
      nvpairs.MG1TrqCmdChange_2_StartTime (1,1) duration = seconds(1500)
      nvpairs.MG1TrqCmdChange_2_EndTime (1,1) duration = seconds(1500 + 2)

      nvpairs.EngineTorqueCommand_1_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.EngineTorqueCommand_2_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.EngineTorqueCommand_3_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.EngTrqCmdChange_1_StartTime (1,1) duration = seconds(500)
      nvpairs.EngTrqCmdChange_1_EndTime (1,1) duration = seconds(500 + 2)
      nvpairs.EngTrqCmdChange_2_StartTime (1,1) duration = seconds(1500)
      nvpairs.EngTrqCmdChange_2_EndTime (1,1) duration = seconds(1500 + 2)

      nvpairs.StopTime (1,1) duration = seconds(2000)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.MG2TorqueCommand_1_Nm;
    x2 = nvpairs.MG2TorqueCommand_2_Nm;
    x3 = nvpairs.MG2TorqueCommand_3_Nm;
    t1 = seconds(nvpairs.MG2TrqCmdChange_1_StartTime);
    t2 = seconds(nvpairs.MG2TrqCmdChange_1_EndTime);
    t3 = seconds(nvpairs.MG2TrqCmdChange_2_StartTime);
    t4 = seconds(nvpairs.MG2TrqCmdChange_2_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t3)
    assert(t3 < t4)
    assert(t4+0.1 < t_end)
    BuildSignal_MG2TorqueCommand(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2 x3 x3     x3], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t3 t4 t4+0.1 t_end]));

    x1 = nvpairs.MG1TorqueCommand_1_Nm;
    x2 = nvpairs.MG1TorqueCommand_2_Nm;
    x3 = nvpairs.MG1TorqueCommand_3_Nm;
    t1 = seconds(nvpairs.MG1TrqCmdChange_1_StartTime);
    t2 = seconds(nvpairs.MG1TrqCmdChange_1_EndTime);
    t3 = seconds(nvpairs.MG1TrqCmdChange_2_StartTime);
    t4 = seconds(nvpairs.MG1TrqCmdChange_2_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t3)
    assert(t3 < t4)
    assert(t4+0.1 < t_end)
    BuildSignal_MG1TorqueCommand(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2 x3 x3     x3], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t3 t4 t4+0.1 t_end]));

    x1 = nvpairs.EngineTorqueCommand_1_Nm;
    x2 = nvpairs.EngineTorqueCommand_2_Nm;
    x3 = nvpairs.EngineTorqueCommand_3_Nm;
    t1 = seconds(nvpairs.EngTrqCmdChange_1_StartTime);
    t2 = seconds(nvpairs.EngTrqCmdChange_1_EndTime);
    t3 = seconds(nvpairs.EngTrqCmdChange_2_StartTime);
    t4 = seconds(nvpairs.EngTrqCmdChange_2_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t3)
    assert(t3 < t4)
    assert(t4+0.1 < t_end)
    BuildSignal_EngineTorqueCommand(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2 x3 x3     x3], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t3 t4 t4+0.1 t_end]));

    x1 = nvpairs.BrakeForce_1_N;
    x2 = nvpairs.BrakeForce_2_N;
    x3 = nvpairs.BrakeForce_3_N;
    t1 = seconds(nvpairs.BrakeForceChange_1_StartTime);
    t2 = seconds(nvpairs.BrakeForceChange_1_EndTime);
    t3 = seconds(nvpairs.BrakeForceChange_2_StartTime);
    t4 = seconds(nvpairs.BrakeForceChange_2_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t3)
    assert(t3 < t4)
    assert(t4+0.1 < t_end)
    BuildSignal_BrakeForce(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2 x3 x3     x3], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t3 t4 t4+0.1 t_end]));

    x1 = nvpairs.RoadGrade_1_pct;
    x2 = nvpairs.RoadGrade_2_pct;
    x3 = nvpairs.RoadGrade_3_pct;
    t1 = seconds(nvpairs.RoadGradeChange_1_StartTime);
    t2 = seconds(nvpairs.RoadGradeChange_1_EndTime);
    t3 = seconds(nvpairs.RoadGradeChange_2_StartTime);
    t4 = seconds(nvpairs.RoadGradeChange_2_EndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t3)
    assert(t3 < t4)
    assert(t4+0.1 < t_end)
    BuildSignal_RoadGrade(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2 x3 x3     x3], ...
      'Time',seconds([0  0.1 t1 t2 t2+0.1 t3 t4 t4+0.1 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);
  end  % function

  function signalData = MG2Drive(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0

      nvpairs.BrakeForce_1_N (1,1) {mustBeNonnegative} = 1000
      nvpairs.BrakeForce_2_N (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForce_3_N (1,1) {mustBeNonnegative} = 1000
      nvpairs.BrakeForceChange_1_StartTime (1,1) duration = seconds(99)
      nvpairs.BrakeForceChange_1_EndTime (1,1) duration = seconds(99 + 1)
      nvpairs.BrakeForceChange_2_StartTime (1,1) duration = seconds(900)
      nvpairs.BrakeForceChange_2_EndTime (1,1) duration = seconds(900 + 30)

      nvpairs.MG2TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG2TorqueCommand_2_Nm (1,1) = 35
      nvpairs.MG2TorqueCommand_3_Nm (1,1) = 0
      nvpairs.MG2TrqCmdChange_1_StartTime (1,1) duration = seconds(100)
      nvpairs.MG2TrqCmdChange_1_EndTime (1,1) duration = seconds(100 + 10)
      nvpairs.MG2TrqCmdChange_2_StartTime (1,1) duration = seconds(700)
      nvpairs.MG2TrqCmdChange_2_EndTime (1,1) duration = seconds(700 + 1)

      nvpairs.StopTime (1,1) duration = seconds(1000)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3( inpObj, ...
      "RoadGrade_1_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_2_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_3_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGradeChange_1_StartTime", seconds(1), ...
      "RoadGradeChange_1_EndTime",   seconds(2), ...
      "RoadGradeChange_2_StartTime", seconds(3), ...
      "RoadGradeChange_2_EndTime",   seconds(4), ...
      ...
      "BrakeForce_1_N", nvpairs.BrakeForce_1_N, ...
      "BrakeForce_2_N", nvpairs.BrakeForce_2_N, ...
      "BrakeForce_3_N", nvpairs.BrakeForce_3_N, ...
      "BrakeForceChange_1_StartTime", nvpairs.BrakeForceChange_1_StartTime, ...
      "BrakeForceChange_1_EndTime",   nvpairs.BrakeForceChange_1_EndTime, ...
      "BrakeForceChange_2_StartTime", nvpairs.BrakeForceChange_2_StartTime, ...
      "BrakeForceChange_2_EndTime",   nvpairs.BrakeForceChange_2_EndTime, ...
      ...
      "MG2TorqueCommand_1_Nm", nvpairs.MG2TorqueCommand_1_Nm, ...
      "MG2TorqueCommand_2_Nm", nvpairs.MG2TorqueCommand_2_Nm, ...
      "MG2TorqueCommand_3_Nm", nvpairs.MG2TorqueCommand_3_Nm, ...
      "MG2TrqCmdChange_1_StartTime", nvpairs.MG2TrqCmdChange_1_StartTime, ...
      "MG2TrqCmdChange_1_EndTime",   nvpairs.MG2TrqCmdChange_1_EndTime, ...
      "MG2TrqCmdChange_2_StartTime", nvpairs.MG2TrqCmdChange_2_StartTime, ...
      "MG2TrqCmdChange_2_EndTime",   nvpairs.MG2TrqCmdChange_2_EndTime, ...
      ...
      "MG1TorqueCommand_1_Nm", 0, ...
      "MG1TorqueCommand_2_Nm", 0, ...
      "MG1TorqueCommand_3_Nm", 0, ...
      "MG1TrqCmdChange_1_StartTime", seconds(1), ...
      "MG1TrqCmdChange_1_EndTime",   seconds(2), ...
      "MG1TrqCmdChange_2_StartTime", seconds(3), ...
      "MG1TrqCmdChange_2_EndTime",   seconds(4), ...
      ...
      "EngineTorqueCommand_1_Nm", 0, ...
      "EngineTorqueCommand_2_Nm", 0, ...
      "EngineTorqueCommand_3_Nm", 0, ...
      "EngTrqCmdChange_1_StartTime", seconds(1), ...
      "EngTrqCmdChange_1_EndTime",   seconds(2), ...
      "EngTrqCmdChange_2_StartTime", seconds(3), ...
      "EngTrqCmdChange_2_EndTime",   seconds(4), ...
      ...
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

  function signalData = MG2Drive_StartEngine(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0

      nvpairs.MG2TorqueCommand_1_Nm (1,1) = 20
      nvpairs.MG2TorqueCommand_2_Nm (1,1) = 20
      nvpairs.MG2TorqueCommand_3_Nm (1,1) = 20
      nvpairs.MG2TrqCmdChange_1_StartTime (1,1) duration = seconds(1)
      nvpairs.MG2TrqCmdChange_1_EndTime (1,1) duration = seconds(2)
      nvpairs.MG2TrqCmdChange_2_StartTime (1,1) duration = seconds(3)
      nvpairs.MG2TrqCmdChange_2_EndTime (1,1) duration = seconds(4)

      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = 3
      nvpairs.MG1TorqueCommand_3_Nm (1,1) = 0
      nvpairs.MG1TrqCmdChange_1_StartTime (1,1) duration = seconds(500)
      nvpairs.MG1TrqCmdChange_1_EndTime (1,1) duration = seconds(500 + 2)
      nvpairs.MG1TrqCmdChange_2_StartTime (1,1) duration = seconds(504)
      nvpairs.MG1TrqCmdChange_2_EndTime (1,1) duration = seconds(504 + 1)

      nvpairs.EngineTorqueCommand_1_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.EngineTorqueCommand_2_Nm (1,1) {mustBeNonnegative} = 70
      nvpairs.EngineTorqueCommand_3_Nm (1,1) {mustBeNonnegative} = 70
      nvpairs.EngTrqCmdChange_1_StartTime (1,1) duration = seconds(502)
      nvpairs.EngTrqCmdChange_1_EndTime (1,1) duration = seconds(502 + 2)
      nvpairs.EngTrqCmdChange_2_StartTime (1,1) duration = seconds(800)
      nvpairs.EngTrqCmdChange_2_EndTime (1,1) duration = seconds(800 + 2)

      nvpairs.StopTime (1,1) duration = seconds(1000)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3( inpObj, ...
      "RoadGrade_1_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_2_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_3_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGradeChange_1_StartTime", seconds(1), ...
      "RoadGradeChange_1_EndTime", seconds(2), ...
      "RoadGradeChange_2_StartTime", seconds(3), ...
      "RoadGradeChange_2_EndTime", seconds(4), ...
      ...
      "MG2TorqueCommand_1_Nm", nvpairs.MG2TorqueCommand_1_Nm, ...
      "MG2TorqueCommand_2_Nm", nvpairs.MG2TorqueCommand_2_Nm, ...
      "MG2TorqueCommand_3_Nm", nvpairs.MG2TorqueCommand_3_Nm, ...
      "MG2TrqCmdChange_1_StartTime", nvpairs.MG2TrqCmdChange_1_StartTime, ...
      "MG2TrqCmdChange_1_EndTime",   nvpairs.MG2TrqCmdChange_1_EndTime, ...
      "MG2TrqCmdChange_2_StartTime", nvpairs.MG2TrqCmdChange_2_StartTime, ...
      "MG2TrqCmdChange_2_EndTime",   nvpairs.MG2TrqCmdChange_2_EndTime, ...
      ...
      "MG1TorqueCommand_1_Nm", nvpairs.MG1TorqueCommand_1_Nm, ...
      "MG1TorqueCommand_2_Nm", nvpairs.MG1TorqueCommand_2_Nm, ...
      "MG1TorqueCommand_3_Nm", nvpairs.MG1TorqueCommand_3_Nm, ...
      "MG1TrqCmdChange_1_StartTime", nvpairs.MG1TrqCmdChange_1_StartTime, ...
      "MG1TrqCmdChange_1_EndTime",   nvpairs.MG1TrqCmdChange_1_EndTime, ...
      "MG1TrqCmdChange_2_StartTime", nvpairs.MG1TrqCmdChange_2_StartTime, ...
      "MG1TrqCmdChange_2_EndTime",   nvpairs.MG1TrqCmdChange_2_EndTime, ...
      ...
      "EngineTorqueCommand_1_Nm", nvpairs.EngineTorqueCommand_1_Nm, ...
      "EngineTorqueCommand_2_Nm", nvpairs.EngineTorqueCommand_2_Nm, ...
      "EngineTorqueCommand_3_Nm", nvpairs.EngineTorqueCommand_3_Nm, ...
      "EngTrqCmdChange_1_StartTime", nvpairs.EngTrqCmdChange_1_StartTime, ...
      "EngTrqCmdChange_1_EndTime",   nvpairs.EngTrqCmdChange_1_EndTime, ...
      "EngTrqCmdChange_2_StartTime", nvpairs.EngTrqCmdChange_2_StartTime, ...
      "EngTrqCmdChange_2_EndTime",   nvpairs.EngTrqCmdChange_2_EndTime, ...
      ...
      "BrakeForce_1_N", 0, ...
      "BrakeForce_2_N", 0, ...
      "BrakeForce_3_N", 0, ...
      "BrakeForceChange_1_StartTime", seconds(1), ...
      "BrakeForceChange_1_EndTime", seconds(2), ...
      "BrakeForceChange_2_StartTime", seconds(3), ...
      "BrakeForceChange_2_EndTime", seconds(4), ...
      ...
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

  function signalData = Parked_EngineChargeBattery(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 6000
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0

      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 12
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_3_Nm (1,1) = -5
      nvpairs.MG1TrqCmdChange_1_StartTime (1,1) duration = seconds(4)
      nvpairs.MG1TrqCmdChange_1_EndTime (1,1) duration = seconds(4 + 1)
      nvpairs.MG1TrqCmdChange_2_StartTime (1,1) duration = seconds(10)
      nvpairs.MG1TrqCmdChange_2_EndTime (1,1) duration = seconds(10 + 2)

      nvpairs.EngineTorqueCommand_1_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.EngineTorqueCommand_2_Nm (1,1) {mustBeNonnegative} = 50
      nvpairs.EngineTorqueCommand_3_Nm (1,1) {mustBeNonnegative} = 100
      nvpairs.EngTrqCmdChange_1_StartTime (1,1) duration = seconds(4)
      nvpairs.EngTrqCmdChange_1_EndTime (1,1) duration = seconds(4 + 1)
      nvpairs.EngTrqCmdChange_2_StartTime (1,1) duration = seconds(10)
      nvpairs.EngTrqCmdChange_2_EndTime (1,1) duration = seconds(10 + 2)

      nvpairs.StopTime (1,1) duration = seconds(100)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3( inpObj, ...
      "MG1TorqueCommand_1_Nm", 12, ...
      "MG1TorqueCommand_2_Nm", 0, ...
      "MG1TorqueCommand_3_Nm", -5, ...
      "MG1TrqCmdChange_1_StartTime", seconds(4), ...
      "MG1TrqCmdChange_1_EndTime", seconds(4 + 1), ...
      "MG1TrqCmdChange_2_StartTime", seconds(10), ...
      "MG1TrqCmdChange_2_EndTime", seconds(10 + 2), ...
      ...
      "EngineTorqueCommand_1_Nm", 0, ...
      "EngineTorqueCommand_2_Nm", 50, ...
      "EngineTorqueCommand_3_Nm", 100, ...
      "EngTrqCmdChange_1_StartTime", seconds(4), ...
      "EngTrqCmdChange_1_EndTime", seconds(4 + 1), ...
      "EngTrqCmdChange_2_StartTime", seconds(10), ...
      "EngTrqCmdChange_2_EndTime", seconds(10 + 2), ...
      ...
      "BrakeForce_1_N", nvpairs.BrakeForce_Const_N, ...
      "BrakeForce_2_N", nvpairs.BrakeForce_Const_N, ...
      "BrakeForce_3_N", nvpairs.BrakeForce_Const_N, ...
      "BrakeForceChange_1_StartTime", seconds(1), ...
      "BrakeForceChange_1_EndTime", seconds(2), ...
      "BrakeForceChange_2_StartTime", seconds(3), ...
      "BrakeForceChange_2_EndTime", seconds(4), ...
      ...
      "RoadGrade_1_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_2_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_3_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGradeChange_1_StartTime", seconds(1), ...
      "RoadGradeChange_1_EndTime", seconds(2), ...
      "RoadGradeChange_2_StartTime", seconds(3), ...
      "RoadGradeChange_2_EndTime", seconds(4), ...
      ...
      "MG2TorqueCommand_1_Nm", 0, ...
      "MG2TorqueCommand_2_Nm", 0, ...
      "MG2TorqueCommand_3_Nm", 0, ...
      "MG2TrqCmdChange_1_StartTime", seconds(1), ...
      "MG2TrqCmdChange_1_EndTime", seconds(2), ...
      "MG2TrqCmdChange_2_StartTime", seconds(3), ...
      "MG2TrqCmdChange_2_EndTime", seconds(4), ...
      ...
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

  function signalData = EngineDrive(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0

      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = 9
      nvpairs.MG1TorqueCommand_3_Nm (1,1) = 0
      nvpairs.MG1TrqCmdChange_1_StartTime (1,1) duration = seconds(10)
      nvpairs.MG1TrqCmdChange_1_EndTime (1,1) duration = seconds(10 + 2)
      nvpairs.MG1TrqCmdChange_2_StartTime (1,1) duration = seconds(15)
      nvpairs.MG1TrqCmdChange_2_EndTime (1,1) duration = seconds(15 + 1)

      nvpairs.EngineTorqueCommand_1_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.EngineTorqueCommand_2_Nm (1,1) {mustBeNonnegative} = 80
      nvpairs.EngineTorqueCommand_3_Nm (1,1) {mustBeNonnegative} = 120
      nvpairs.EngTrqCmdChange_1_StartTime (1,1) duration = seconds(13)
      nvpairs.EngTrqCmdChange_1_EndTime (1,1) duration = seconds(13 + 2)
      nvpairs.EngTrqCmdChange_2_StartTime (1,1) duration = seconds(50)
      nvpairs.EngTrqCmdChange_2_EndTime (1,1) duration = seconds(50 + 2)

      nvpairs.StopTime (1,1) duration = seconds(100)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3( inpObj, ...
      "RoadGrade_1_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_2_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_3_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGradeChange_1_StartTime", seconds(1), ...
      "RoadGradeChange_1_EndTime",   seconds(2), ...
      "RoadGradeChange_2_StartTime", seconds(3), ...
      "RoadGradeChange_2_EndTime",   seconds(4), ...
      ...
      "MG2TorqueCommand_1_Nm", 0, ...
      "MG2TorqueCommand_2_Nm", 0, ...
      "MG2TorqueCommand_3_Nm", 0, ...
      "MG2TrqCmdChange_1_StartTime", seconds(1), ...
      "MG2TrqCmdChange_1_EndTime",   seconds(2), ...
      "MG2TrqCmdChange_2_StartTime", seconds(3), ...
      "MG2TrqCmdChange_2_EndTime",   seconds(4), ...
      ...
      "MG1TorqueCommand_1_Nm", nvpairs.MG1TorqueCommand_1_Nm, ...
      "MG1TorqueCommand_2_Nm", nvpairs.MG1TorqueCommand_2_Nm, ...
      "MG1TorqueCommand_3_Nm", nvpairs.MG1TorqueCommand_3_Nm, ...
      "MG1TrqCmdChange_1_StartTime", nvpairs.MG1TrqCmdChange_1_StartTime, ...
      "MG1TrqCmdChange_1_EndTime",   nvpairs.MG1TrqCmdChange_1_EndTime, ...
      "MG1TrqCmdChange_2_StartTime", nvpairs.MG1TrqCmdChange_2_StartTime, ...
      "MG1TrqCmdChange_2_EndTime",   nvpairs.MG1TrqCmdChange_2_EndTime, ...
      ...
      "EngineTorqueCommand_1_Nm", nvpairs.EngineTorqueCommand_1_Nm, ...
      "EngineTorqueCommand_2_Nm", nvpairs.EngineTorqueCommand_2_Nm, ...
      "EngineTorqueCommand_3_Nm", nvpairs.EngineTorqueCommand_3_Nm, ...
      "EngTrqCmdChange_1_StartTime", nvpairs.EngTrqCmdChange_1_StartTime, ...
      "EngTrqCmdChange_1_EndTime",   nvpairs.EngTrqCmdChange_1_EndTime, ...
      "EngTrqCmdChange_2_StartTime", nvpairs.EngTrqCmdChange_2_StartTime, ...
      "EngTrqCmdChange_2_EndTime",   nvpairs.EngTrqCmdChange_2_EndTime, ...
      ...
      "BrakeForce_1_N", 0, ...
      "BrakeForce_2_N", 0, ...
      "BrakeForce_3_N", 0, ...
      "BrakeForceChange_1_StartTime", seconds(1), ...
      "BrakeForceChange_1_EndTime", seconds(2), ...
      "BrakeForceChange_2_StartTime", seconds(3), ...
      "BrakeForceChange_2_EndTime", seconds(4), ...
      ...
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

  function signalData = MG1Drive(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0

      nvpairs.BrakeForce_1_N (1,1) {mustBeNonnegative} = 1000
      nvpairs.BrakeForce_2_N (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForce_3_N (1,1) {mustBeNonnegative} = 1000
      nvpairs.BrakeForceChange_1_StartTime (1,1) duration = seconds(99)
      nvpairs.BrakeForceChange_1_EndTime (1,1) duration = seconds(99 + 1)
      nvpairs.BrakeForceChange_2_StartTime (1,1) duration = seconds(900)
      nvpairs.BrakeForceChange_2_EndTime (1,1) duration = seconds(900 + 30)

      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = -35
      nvpairs.MG1TorqueCommand_3_Nm (1,1) = 0
      nvpairs.MG1TrqCmdChange_1_StartTime (1,1) duration = seconds(100)
      nvpairs.MG1TrqCmdChange_1_EndTime (1,1) duration = seconds(100 + 10)
      nvpairs.MG1TrqCmdChange_2_StartTime (1,1) duration = seconds(700)
      nvpairs.MG1TrqCmdChange_2_EndTime (1,1) duration = seconds(700 + 1)

      nvpairs.StopTime (1,1) duration = seconds(1000)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3( inpObj, ...
      "RoadGrade_1_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_2_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_3_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGradeChange_1_StartTime", seconds(1), ...
      "RoadGradeChange_1_EndTime", seconds(2), ...
      "RoadGradeChange_2_StartTime", seconds(3), ...
      "RoadGradeChange_2_EndTime", seconds(4), ...
      ...
      "BrakeForce_1_N", nvpairs.BrakeForce_1_N, ...
      "BrakeForce_2_N", nvpairs.BrakeForce_2_N, ...
      "BrakeForce_3_N", nvpairs.BrakeForce_3_N, ...
      "BrakeForceChange_1_StartTime", nvpairs.BrakeForceChange_1_StartTime, ...
      "BrakeForceChange_1_EndTime",   nvpairs.BrakeForceChange_1_EndTime, ...
      "BrakeForceChange_2_StartTime", nvpairs.BrakeForceChange_2_StartTime, ...
      "BrakeForceChange_2_EndTime",   nvpairs.BrakeForceChange_2_EndTime, ...
      ...
      "MG2TorqueCommand_1_Nm", 0, ...
      "MG2TorqueCommand_2_Nm", 0, ...
      "MG2TorqueCommand_3_Nm", 0, ...
      "MG2TrqCmdChange_1_StartTime", seconds(1), ...
      "MG2TrqCmdChange_1_EndTime", seconds(2), ...
      "MG2TrqCmdChange_2_StartTime", seconds(3), ...
      "MG2TrqCmdChange_2_EndTime", seconds(4), ...
      ...
      "MG1TorqueCommand_1_Nm", nvpairs.MG1TorqueCommand_1_Nm, ...
      "MG1TorqueCommand_2_Nm", nvpairs.MG1TorqueCommand_2_Nm, ...
      "MG1TorqueCommand_3_Nm", nvpairs.MG1TorqueCommand_3_Nm, ...
      "MG1TrqCmdChange_1_StartTime", nvpairs.MG1TrqCmdChange_1_StartTime, ...
      "MG1TrqCmdChange_1_EndTime",   nvpairs.MG1TrqCmdChange_1_EndTime, ...
      "MG1TrqCmdChange_2_StartTime", nvpairs.MG1TrqCmdChange_2_StartTime, ...
      "MG1TrqCmdChange_2_EndTime",   nvpairs.MG1TrqCmdChange_2_EndTime, ...
      ...
      "EngineTorqueCommand_1_Nm", 0, ...
      "EngineTorqueCommand_2_Nm", 0, ...
      "EngineTorqueCommand_3_Nm", 0, ...
      "EngTrqCmdChange_1_StartTime", seconds(1), ...
      "EngTrqCmdChange_1_EndTime", seconds(2), ...
      "EngTrqCmdChange_2_StartTime", seconds(3), ...
      "EngTrqCmdChange_2_EndTime", seconds(4), ...
      ...
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

  function signalData = PowerSplitDrive(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0

      nvpairs.MG2TorqueCommand_1_Nm (1,1) = 10
      nvpairs.MG2TorqueCommand_2_Nm (1,1) = 10
      nvpairs.MG2TorqueCommand_3_Nm (1,1) = 10
      nvpairs.MG2TrqCmdChange_1_StartTime (1,1) duration = seconds(1)
      nvpairs.MG2TrqCmdChange_1_EndTime (1,1) duration = seconds(2)
      nvpairs.MG2TrqCmdChange_2_StartTime (1,1) duration = seconds(3)
      nvpairs.MG2TrqCmdChange_2_EndTime (1,1) duration = seconds(4)

      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 7
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = -4
      nvpairs.MG1TorqueCommand_3_Nm (1,1) = -7
      nvpairs.MG1TrqCmdChange_1_StartTime (1,1) duration = seconds(5)
      nvpairs.MG1TrqCmdChange_1_EndTime (1,1) duration = seconds(5 + 2)
      nvpairs.MG1TrqCmdChange_2_StartTime (1,1) duration = seconds(300)
      nvpairs.MG1TrqCmdChange_2_EndTime (1,1) duration = seconds(300 + 2)

      nvpairs.EngineTorqueCommand_1_Nm (1,1) {mustBeNonnegative} = 50
      nvpairs.EngineTorqueCommand_2_Nm (1,1) {mustBeNonnegative} = 80
      nvpairs.EngineTorqueCommand_3_Nm (1,1) {mustBeNonnegative} = 80
      nvpairs.EngTrqCmdChange_1_StartTime (1,1) duration = seconds(100)
      nvpairs.EngTrqCmdChange_1_EndTime (1,1) duration = seconds(100 + 2)
      nvpairs.EngTrqCmdChange_2_StartTime (1,1) duration = seconds(150)
      nvpairs.EngTrqCmdChange_2_EndTime (1,1) duration = seconds(150 + 2)

      nvpairs.StopTime (1,1) duration = seconds(500)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3( inpObj, ...
      "RoadGrade_1_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_2_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_3_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGradeChange_1_StartTime", seconds(1), ...
      "RoadGradeChange_1_EndTime",   seconds(2), ...
      "RoadGradeChange_2_StartTime", seconds(3), ...
      "RoadGradeChange_2_EndTime",   seconds(4), ...
      ...
      "MG2TorqueCommand_1_Nm", nvpairs.MG2TorqueCommand_1_Nm, ...
      "MG2TorqueCommand_2_Nm", nvpairs.MG2TorqueCommand_2_Nm, ...
      "MG2TorqueCommand_3_Nm", nvpairs.MG2TorqueCommand_3_Nm, ...
      "MG2TrqCmdChange_1_StartTime", nvpairs.MG2TrqCmdChange_1_StartTime, ...
      "MG2TrqCmdChange_1_EndTime",   nvpairs.MG2TrqCmdChange_1_EndTime, ...
      "MG2TrqCmdChange_2_StartTime", nvpairs.MG2TrqCmdChange_2_StartTime, ...
      "MG2TrqCmdChange_2_EndTime",   nvpairs.MG2TrqCmdChange_2_EndTime, ...
      ...
      "MG1TorqueCommand_1_Nm", nvpairs.MG1TorqueCommand_1_Nm, ...
      "MG1TorqueCommand_2_Nm", nvpairs.MG1TorqueCommand_2_Nm, ...
      "MG1TorqueCommand_3_Nm", nvpairs.MG1TorqueCommand_3_Nm, ...
      "MG1TrqCmdChange_1_StartTime", nvpairs.MG1TrqCmdChange_1_StartTime, ...
      "MG1TrqCmdChange_1_EndTime",   nvpairs.MG1TrqCmdChange_1_EndTime, ...
      "MG1TrqCmdChange_2_StartTime", nvpairs.MG1TrqCmdChange_2_StartTime, ...
      "MG1TrqCmdChange_2_EndTime",   nvpairs.MG1TrqCmdChange_2_EndTime, ...
      ...
      "EngineTorqueCommand_1_Nm", nvpairs.EngineTorqueCommand_1_Nm, ...
      "EngineTorqueCommand_2_Nm", nvpairs.EngineTorqueCommand_2_Nm, ...
      "EngineTorqueCommand_3_Nm", nvpairs.EngineTorqueCommand_3_Nm, ...
      "EngTrqCmdChange_1_StartTime", nvpairs.EngTrqCmdChange_1_StartTime, ...
      "EngTrqCmdChange_1_EndTime",   nvpairs.EngTrqCmdChange_1_EndTime, ...
      "EngTrqCmdChange_2_StartTime", nvpairs.EngTrqCmdChange_2_StartTime, ...
      "EngTrqCmdChange_2_EndTime",   nvpairs.EngTrqCmdChange_2_EndTime, ...
      ...
      "BrakeForce_1_N", 0, ...
      "BrakeForce_2_N", 0, ...
      "BrakeForce_3_N", 0, ...
      "BrakeForceChange_1_StartTime", seconds(1), ...
      "BrakeForceChange_1_EndTime", seconds(2), ...
      "BrakeForceChange_2_StartTime", seconds(3), ...
      "BrakeForceChange_2_EndTime", seconds(4), ...
      ...
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

  function signalData = Downhill(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = -6

      nvpairs.MG2TorqueCommand_1_Nm (1,1) = 0
      nvpairs.MG2TorqueCommand_2_Nm (1,1) = -3
      nvpairs.MG2TorqueCommand_3_Nm (1,1) = -10
      nvpairs.MG2TrqCmdChange_1_StartTime (1,1) duration = seconds(300)
      nvpairs.MG2TrqCmdChange_1_EndTime (1,1) duration = seconds(300 + 2)
      nvpairs.MG2TrqCmdChange_2_StartTime (1,1) duration = seconds(600)
      nvpairs.MG2TrqCmdChange_2_EndTime (1,1) duration = seconds(600 + 2)

      nvpairs.StopTime (1,1) duration = seconds(1000)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Step3( inpObj, ...
      "RoadGrade_1_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_2_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGrade_3_pct", nvpairs.RoadGrade_Const_pct, ...
      "RoadGradeChange_1_StartTime", seconds(1), ...
      "RoadGradeChange_1_EndTime",   seconds(2), ...
      "RoadGradeChange_2_StartTime", seconds(3), ...
      "RoadGradeChange_2_EndTime",   seconds(4), ...
      ...
      "MG2TorqueCommand_1_Nm", nvpairs.MG2TorqueCommand_1_Nm, ...
      "MG2TorqueCommand_2_Nm", nvpairs.MG2TorqueCommand_2_Nm, ...
      "MG2TorqueCommand_3_Nm", nvpairs.MG2TorqueCommand_3_Nm, ...
      "MG2TrqCmdChange_1_StartTime", nvpairs.MG2TrqCmdChange_1_StartTime, ...
      "MG2TrqCmdChange_1_EndTime",   nvpairs.MG2TrqCmdChange_1_EndTime, ...
      "MG2TrqCmdChange_2_StartTime", nvpairs.MG2TrqCmdChange_2_StartTime, ...
      "MG2TrqCmdChange_2_EndTime",   nvpairs.MG2TrqCmdChange_2_EndTime, ...
      ...
      "MG1TorqueCommand_1_Nm", 0, ...
      "MG1TorqueCommand_2_Nm", 0, ...
      "MG1TorqueCommand_3_Nm", 0, ...
      "MG1TrqCmdChange_1_StartTime", seconds(1), ...
      "MG1TrqCmdChange_1_EndTime",   seconds(2), ...
      "MG1TrqCmdChange_2_StartTime", seconds(3), ...
      "MG1TrqCmdChange_2_EndTime",   seconds(4), ...
      ...
      "EngineTorqueCommand_1_Nm", 0, ...
      "EngineTorqueCommand_2_Nm", 0, ...
      "EngineTorqueCommand_3_Nm", 0, ...
      "EngTrqCmdChange_1_StartTime", seconds(1), ...
      "EngTrqCmdChange_1_EndTime",   seconds(2), ...
      "EngTrqCmdChange_2_StartTime", seconds(3), ...
      "EngTrqCmdChange_2_EndTime",   seconds(4), ...
      ...
      "BrakeForce_1_N", 0, ...
      "BrakeForce_2_N", 0, ...
      "BrakeForce_3_N", 0, ...
      "BrakeForceChange_1_StartTime", seconds(1), ...
      "BrakeForceChange_1_EndTime",   seconds(2), ...
      "BrakeForceChange_2_StartTime", seconds(3), ...
      "BrakeForceChange_2_EndTime",   seconds(4), ...
      ...
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

end  % methods

methods (Access = private)

  %% Build signal trace with timetable

  function inpObj = BuildSignal_MG2TorqueCommand(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.Mg2TrqCmd = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.Mg2TrqCmd.Properties.VariableNames = {'Mg2TrqCmd'};
    inpObj.Mg2TrqCmd.Properties.VariableUnits = {'N*m'};
    inpObj.Mg2TrqCmd.Properties.VariableContinuity = {'continuous'};
    inpObj.Mg2TrqCmd = ...
      retime(inpObj.Mg2TrqCmd, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_MG1TorqueCommand(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.Mg1TrqCmd = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.Mg1TrqCmd.Properties.VariableNames = {'Mg1TrqCmd'};
    inpObj.Mg1TrqCmd.Properties.VariableUnits = {'N*m'};
    inpObj.Mg1TrqCmd.Properties.VariableContinuity = {'continuous'};
    inpObj.Mg1TrqCmd = ...
      retime(inpObj.Mg1TrqCmd, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_EngineTorqueCommand(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.EngTrqCmd = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.EngTrqCmd.Properties.VariableNames = {'EngTrqCmd'};
    inpObj.EngTrqCmd.Properties.VariableUnits = {'N*m'};
    inpObj.EngTrqCmd.Properties.VariableContinuity = {'continuous'};
    inpObj.EngTrqCmd = ...
      retime(inpObj.EngTrqCmd, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end
  function inpObj = BuildSignal_BrakeForce(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.BrakeForce = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.BrakeForce.Properties.VariableNames = {'BrakeForce'};
    inpObj.BrakeForce.Properties.VariableUnits = {'N'};
    inpObj.BrakeForce.Properties.VariableContinuity = {'continuous'};
    inpObj.BrakeForce = ...
      retime(inpObj.BrakeForce, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_RoadGrade(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.RoadGrade = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.RoadGrade.Properties.VariableNames = {'RoadGrade'};
    inpObj.RoadGrade.Properties.VariableUnits = {'%'};
    inpObj.RoadGrade.Properties.VariableContinuity = {'continuous'};
    inpObj.RoadGrade = ...
      retime(inpObj.RoadGrade, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function signalData = BundleSignals(inpObj)
  %%
    signalData.Signals.Mg2TrqCmd = inpObj.Mg2TrqCmd;
    signalData.Signals.Mg1TrqCmd = inpObj.Mg1TrqCmd;
    signalData.Signals.EngTrqCmd = inpObj.EngTrqCmd;
    signalData.Signals.BrakeForce = inpObj.BrakeForce;
    signalData.Signals.RoadGrade = inpObj.RoadGrade;

    signalData.Bus = Simulink.Bus;
    sigs = {
      inpObj.Mg2TrqCmd ...
      inpObj.Mg1TrqCmd ...
      inpObj.EngTrqCmd ...
      inpObj.BrakeForce ...
      inpObj.RoadGrade };
    for i = 1:numel(sigs)
      signalData.Bus.Elements(i) = Simulink.BusElement;
      signalData.Bus.Elements(i).Name = sigs{i}.Properties.VariableNames{1};
      signalData.Bus.Elements(i).Unit = sigs{i}.Properties.VariableUnits{1};
    end

    % Additional data to return
    opts.FunctionName = inpObj.FunctionName;
    opts.StopTime_s = seconds(inpObj.StopTime);
    opts.TimeStamp = string(datetime("now", "Format","yyyy-MM-dd HH:mm:ss"));

    if isprop(inpObj, 'ParentFigure')
      opts.ParentFigure = inpObj.ParentFigure;
    end

    signalData.Options = opts;
  end  % function

end  % methods
end  % classdef