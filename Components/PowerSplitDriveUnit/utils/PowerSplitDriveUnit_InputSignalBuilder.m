classdef PowerSplitDriveUnit_InputSignalBuilder < handle
% Class implementation of Input Signal Builder

% Copyright 2022 The MathWorks, Inc.

% You can run this class by selecting the following code
% and pressing the F9 key.
%{
PSDU_InputData = PowerSplitDriveUnit_InputSignalBuilder().Input_Constant;
PSDU_InputSignals = PSDU_InputData.Signals;
PSDU_InputBus = PSDU_InputData.Bus;
%}

properties
  % ### Signals

  EngTrqCmd timetable
  Mg1TrqCmd timetable
  Mg2TrqCmd timetable

  HVBattV timetable

  AxleSpd_OnOff timetable
  AxleSpd timetable
  AxleTrq timetable
  BrkForce timetable

  % ### Other properties

  FunctionName (1,1) string
  StopTime (1,1) duration

  ParentFigure (1,1)  % must be of type matlab.ui.Figure
  Plot_tf (1,1) logical = false
  VisiblePlot_tf (1,1) logical = true
  FigureWidth (1,1) double = 400
  FigureHeight (1,1) double = 400
  LineWidth (1,1) double = 2

  SavePlot_tf (1,1) logical = false
  SavePlotImageFileName (1,1) {mustBeTextScalar} = "image_input_signals.png"
end

methods

  function inpObj = PowerSplitDriveUnit_InputSignalBuilder(nvpairs)
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
    Input_Constant(inpObj);
    inpObj.Plot_tf = tmp;

  end

  function plotSignals(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.ParentFigure (1,1)
    end

    syncedInputs = synchronize( ...
                      inpObj.EngTrqCmd, ...
                      inpObj.Mg1TrqCmd, ...
                      inpObj.Mg2TrqCmd, ...
                      inpObj.HVBattV, ...
                      inpObj.AxleSpd_OnOff, ...
                      inpObj.AxleSpd, ...
                      inpObj.AxleTrq, ...
                      inpObj.BrkForce );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.EngTrqCmd), ...
      addUnitString(inpObj.Mg1TrqCmd), ...
      addUnitString(inpObj.Mg2TrqCmd), ...
      addUnitString(inpObj.HVBattV), ...
      addUnitString(inpObj.AxleSpd_OnOff), ...
      addUnitString(inpObj.AxleSpd), ...
      addUnitString(inpObj.AxleSpd), ...
      addUnitString(inpObj.BrkForce) };

    if not(inpObj.VisiblePlot_tf)
      % Invisible figure.
      inpObj.ParentFigure = figure(Visible = 'off');
    elseif isfield(nvpairs, 'ParentFigure')
      % This function's ParentFigure option is specified.
      assert(isa(nvpairs.ParentFigure, 'matlab.ui.Figure'))
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

  %% Input Signal Patterns

  function signalData = Input_Constant(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(600)
      nvpairs.EngineTorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.MG1TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.MG2TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.HVBatteryVoltage_Const_V (1,1) {mustBePositive} = 200
      nvpairs.AxleSpeed_OnOff_Const (1,1) = 0
      nvpairs.AxleSpeed_Const_rpm (1,1) = 0
      nvpairs.AxleTorque_Const_Nm (1,1) = 0
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.EngineTorqueCommand_Const_Nm;
    BuildSignal_EngineTorqueCommand(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.MG1TorqueCommand_Const_Nm;
    BuildSignal_MG1TorqueCommand(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.MG2TorqueCommand_Const_Nm;
    BuildSignal_MG2TorqueCommand(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.HVBatteryVoltage_Const_V;
    BuildSignal_HVBatteryVoltage(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeed_OnOff_Const;
    BuildSignal_AxleSpeed_OnOff(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeed_Const_rpm;
    BuildSignal_AxleSpeed(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleTorque_Const_Nm;
    BuildSignal_AxleTorque(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.BrakeForce_Const_N;
    BuildSignal_BrakeForce(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);
  end  % function

  function signalData = DriveFromAxle(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(600)
      nvpairs.EngineTorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.MG1TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.MG2TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.HVBatteryVoltage_Const_V (1,1) {mustBePositive} = 200
      nvpairs.AxleSpeed_OnOff_Const (1,1) = 0
      nvpairs.AxleSpeed_Const_rpm (1,1) = 0
      nvpairs.AxleTorque_Const_Nm (1,1) = 30
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    signalData = Input_Constant( inpObj, ...
      StopTime = nvpairs.StopTime, ...
      EngineTorqueCommand_Const_Nm = nvpairs.EngineTorqueCommand_Const_Nm, ...
      MG1TorqueCommand_Const_Nm = nvpairs.MG1TorqueCommand_Const_Nm, ...
      MG2TorqueCommand_Const_Nm = nvpairs.MG2TorqueCommand_Const_Nm, ...
      HVBatteryVoltage_Const_V = nvpairs.HVBatteryVoltage_Const_V, ...
      AxleSpeed_OnOff_Const = nvpairs.AxleSpeed_OnOff_Const, ...
      AxleSpeed_Const_rpm = nvpairs.AxleSpeed_Const_rpm, ...
      AxleTorque_Const_Nm = nvpairs.AxleTorque_Const_Nm, ...
      BrakeForce_Const_N = nvpairs.BrakeForce_Const_N );

    inpObj.Plot_tf = tmp;

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end
  end  % function

  function signalData = DriveWithMG2(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(600)
      nvpairs.EngineTorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.MG1TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.MG2TorqueCommand_Const_Nm (1,1) = 20
      nvpairs.HVBatteryVoltage_Const_V (1,1) {mustBePositive} = 200
      nvpairs.AxleSpeed_OnOff_Const (1,1) = 0
      nvpairs.AxleSpeed_Const_rpm (1,1) = 0
      nvpairs.AxleTorque_Const_Nm (1,1) = 0
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    signalData = Input_Constant( inpObj, ...
      StopTime = nvpairs.StopTime, ...
      EngineTorqueCommand_Const_Nm = nvpairs.EngineTorqueCommand_Const_Nm, ...
      MG1TorqueCommand_Const_Nm = nvpairs.MG1TorqueCommand_Const_Nm, ...
      MG2TorqueCommand_Const_Nm = nvpairs.MG2TorqueCommand_Const_Nm, ...
      HVBatteryVoltage_Const_V = nvpairs.HVBatteryVoltage_Const_V, ...
      AxleSpeed_OnOff_Const = nvpairs.AxleSpeed_OnOff_Const, ...
      AxleSpeed_Const_rpm = nvpairs.AxleSpeed_Const_rpm, ...
      AxleTorque_Const_Nm = nvpairs.AxleTorque_Const_Nm, ...
      BrakeForce_Const_N = nvpairs.BrakeForce_Const_N );

    inpObj.Plot_tf = tmp;

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end
  end  % function

  function signalData = DriveWithMG1(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.MG1Torque_1_Nm (1,1) = 0
      nvpairs.MG1Torque_2_Nm (1,1) = -10
      nvpairs.MG1Torque_3_Nm (1,1) = 10

      nvpairs.MG1TorqueChange_1_StartTime (1,1) duration = seconds(10)
      nvpairs.MG1TorqueChange_1_EndTime (1,1) duration = seconds(10 + 10)
      nvpairs.MG1TorqueChange_2_StartTime (1,1) duration = seconds(20 + 100)
      nvpairs.MG1TorqueChange_2_EndTime (1,1) duration = seconds(120 + 10)
      nvpairs.StopTime (1,1) duration = seconds(130 + 170)

      nvpairs.EngineTorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.MG2TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.HVBatteryVoltage_Const_V (1,1) {mustBePositive} = 200
      nvpairs.AxleSpeed_OnOff_Const (1,1) = 0
      nvpairs.AxleSpeed_Const_rpm (1,1) = 0
      nvpairs.AxleTorque_Const_Nm (1,1) = 0
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.EngineTorqueCommand_Const_Nm;
    BuildSignal_EngineTorqueCommand(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.MG1Torque_1_Nm;
    x2 = nvpairs.MG1Torque_2_Nm;
    x3 = nvpairs.MG1Torque_3_Nm;
    t1 = seconds(nvpairs.MG1TorqueChange_1_StartTime);
    t2 = seconds(nvpairs.MG1TorqueChange_1_EndTime);
    t3 = seconds(nvpairs.MG1TorqueChange_2_StartTime);
    t4 = seconds(nvpairs.MG1TorqueChange_2_EndTime);
    assert(0.01 < t1)
    assert(t1 < t2)
    assert(t2+0.01 < t3)
    assert(t3 < t4)
    assert(t4+0.01 < t_end)
    BuildSignal_MG1TorqueCommand(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    x1 = nvpairs.MG2TorqueCommand_Const_Nm;
    BuildSignal_MG2TorqueCommand(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.HVBatteryVoltage_Const_V;
    BuildSignal_HVBatteryVoltage(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeed_OnOff_Const;
    BuildSignal_AxleSpeed_OnOff(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeed_Const_rpm;
    BuildSignal_AxleSpeed(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleTorque_Const_Nm;
    BuildSignal_AxleTorque(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.BrakeForce_Const_N;
    BuildSignal_BrakeForce(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);
  end  % function

  function signalData = DriveWithMG1_LockAxle(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.MG1Torque_1_Nm (1,1) = 0
      nvpairs.MG1Torque_2_Nm (1,1) = -10
      nvpairs.MG1Torque_3_Nm (1,1) = 10

      nvpairs.MG1TorqueChange_1_StartTime (1,1) duration = seconds(10)
      nvpairs.MG1TorqueChange_1_EndTime (1,1) duration = seconds(10 + 10)
      nvpairs.MG1TorqueChange_2_StartTime (1,1) duration = seconds(20 + 100)
      nvpairs.MG1TorqueChange_2_EndTime (1,1) duration = seconds(120 + 10)
      nvpairs.StopTime (1,1) duration = seconds(130 + 170)

      nvpairs.AxleSpeed_OnOff_Const (1,1) = 1  % Input speed to axle
      nvpairs.AxleSpeed_Const_rpm (1,1) = 0    % Speed 0 -> lock axle

      nvpairs.EngineTorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.MG2TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.HVBatteryVoltage_Const_V (1,1) {mustBePositive} = 200
      nvpairs.AxleTorque_Const_Nm (1,1) = 0
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    signalData = DriveWithMG1( inpObj, ...
      MG1Torque_1_Nm = nvpairs.MG1Torque_1_Nm, ...
      MG1Torque_2_Nm = nvpairs.MG1Torque_2_Nm, ...
      MG1Torque_3_Nm = nvpairs.MG1Torque_3_Nm, ...
      MG1TorqueChange_1_StartTime = nvpairs.MG1TorqueChange_1_StartTime, ...
      MG1TorqueChange_1_EndTime = nvpairs.MG1TorqueChange_1_EndTime, ...
      MG1TorqueChange_2_StartTime = nvpairs.MG1TorqueChange_2_StartTime, ...
      MG1TorqueChange_2_EndTime = nvpairs.MG1TorqueChange_2_EndTime, ...
      StopTime = nvpairs.StopTime, ...
      EngineTorqueCommand_Const_Nm = nvpairs.EngineTorqueCommand_Const_Nm, ...
      MG2TorqueCommand_Const_Nm = nvpairs.MG2TorqueCommand_Const_Nm, ...
      HVBatteryVoltage_Const_V = nvpairs.HVBatteryVoltage_Const_V, ...
      AxleSpeed_OnOff_Const = nvpairs.AxleSpeed_OnOff_Const, ...
      AxleSpeed_Const_rpm = nvpairs.AxleSpeed_Const_rpm, ...
      AxleTorque_Const_Nm = nvpairs.AxleTorque_Const_Nm, ...
      BrakeForce_Const_N = nvpairs.BrakeForce_Const_N );

    inpObj.Plot_tf = tmp;

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end
  end  % function

  function signalData = StartEngineWithMG1_ThenSplitPower(inpObj, nvpairs)
  %%
    arguments
      inpObj

      % At first, MG1 drives engine.
      nvpairs.BrakeForce_1_N (1,1) {mustBeNonnegative} = 7000
      nvpairs.MG1TorqueCommand_1_Nm (1,1) = 15  % Start engine with MG1
      nvpairs.EngineTorqueCommand_1_Nm (1,1) {mustBeNonnegative} = 0

      % Start engine.
      nvpairs.EngineTorqueCommand_2_Nm (1,1) {mustBeNonnegative} = 45
      nvpairs.EngineTorqueCommandChange_1_StartTime (1,1) duration = seconds(5)
      nvpairs.EngineTorqueCommandChange_1_EndTime (1,1) duration = seconds(5 + 1)

      % Stop sending torque request to MG1.
      nvpairs.MG1TorqueCommand_2_Nm (1,1) = 0
      nvpairs.MG1TorqueCommandChange_1_StartTime (1,1) duration = seconds(5.5)
      nvpairs.MG1TorqueCommandChange_1_EndTime (1,1) duration = seconds(5.5 + 0.5)

      % Release brake.
      nvpairs.BrakeForce_2_N (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForceChange_1_StartTime (1,1) duration = seconds(6 + 4)
      nvpairs.BrakeForceChange_1_EndTime (1,1) duration = seconds(10 + 1)

      % Rev up engine
      nvpairs.EngineTorqueCommand_3_Nm (1,1) {mustBeNonnegative} = 90
      nvpairs.EngineTorqueCommandChange_2_StartTime (1,1) duration = seconds(11 + 4)
      nvpairs.EngineTorqueCommandChange_2_EndTime (1,1) duration = seconds(15 + 1)

      % Split engine power with MG1
      nvpairs.MG1TorqueCommand_3_Nm (1,1) = -5  % Split engine power with MG1
      nvpairs.MG1TorqueCommandChange_2_StartTime (1,1) duration = seconds(16 + 14)
      nvpairs.MG1TorqueCommandChange_2_EndTime (1,1) duration = seconds(30 + 2)

      % Optionally, use MG1 for driving
      nvpairs.MG1TorqueCommand_4_Nm (1,1) = 0
      nvpairs.MG1TorqueCommandChange_3_StartTime (1,1) duration = seconds(32 + 8)
      nvpairs.MG1TorqueCommandChange_3_EndTime (1,1) duration = seconds(40 + 2)

      nvpairs.StopTime (1,1) duration = seconds(42 + 18)

      nvpairs.MG2TorqueCommand_Const_Nm (1,1) = 0
      nvpairs.HVBatteryVoltage_Const_V (1,1) {mustBePositive} = 200
      nvpairs.AxleSpeed_OnOff_Const (1,1) = 0
      nvpairs.AxleSpeed_Const_rpm (1,1) = 0
      nvpairs.AxleTorque_Const_Nm (1,1) = 0
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.EngineTorqueCommand_1_Nm;
    x2 = nvpairs.EngineTorqueCommand_2_Nm;
    x3 = nvpairs.EngineTorqueCommand_3_Nm;
    t1 = seconds(nvpairs.EngineTorqueCommandChange_1_StartTime);
    t2 = seconds(nvpairs.EngineTorqueCommandChange_1_EndTime);
    t3 = seconds(nvpairs.EngineTorqueCommandChange_2_StartTime);
    t4 = seconds(nvpairs.EngineTorqueCommandChange_2_EndTime);
    assert(0.01 < t1)
    assert(t1 < t2)
    assert(t2+0.01 < t3)
    assert(t3 < t4)
    assert(t4+0.01 < t_end)
    BuildSignal_EngineTorqueCommand(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    x1 = nvpairs.MG1TorqueCommand_1_Nm;
    x2 = nvpairs.MG1TorqueCommand_2_Nm;
    x3 = nvpairs.MG1TorqueCommand_3_Nm;
    x4 = nvpairs.MG1TorqueCommand_4_Nm;
    t1 = seconds(nvpairs.MG1TorqueCommandChange_1_StartTime);
    t2 = seconds(nvpairs.MG1TorqueCommandChange_1_EndTime);
    t3 = seconds(nvpairs.MG1TorqueCommandChange_2_StartTime);
    t4 = seconds(nvpairs.MG1TorqueCommandChange_2_EndTime);
    t5 = seconds(nvpairs.MG1TorqueCommandChange_3_StartTime);
    t6 = seconds(nvpairs.MG1TorqueCommandChange_3_EndTime);
    assert(0.01 < t1)
    assert(t1 < t2)
    assert(t2+0.01 < t3)
    assert(t3 < t4)
    assert(t4+0.01 < t5)
    assert(t5 < t6)
    assert(t6+0.01 < t_end)
    BuildSignal_MG1TorqueCommand(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2 x3 x3      x3 x4 x4      x4], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t5 t6 t6+0.01 t_end]));

    x1 = nvpairs.MG2TorqueCommand_Const_Nm;
    BuildSignal_MG2TorqueCommand(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.HVBatteryVoltage_Const_V;
    BuildSignal_HVBatteryVoltage(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeed_OnOff_Const;
    BuildSignal_AxleSpeed_OnOff(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeed_Const_rpm;
    BuildSignal_AxleSpeed(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleTorque_Const_Nm;
    BuildSignal_AxleTorque(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.BrakeForce_1_N;
    x2 = nvpairs.BrakeForce_2_N;
    t1 = seconds(nvpairs.BrakeForceChange_1_StartTime);
    t2 = seconds(nvpairs.BrakeForceChange_1_EndTime);
    assert(0.01 < t1)
    assert(t1 < t2)
    assert(t2+0.01 < t_end)
    BuildSignal_BrakeForce(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);
  end  % function

end  % methods

methods (Access = private)

  %% Build signal trace with timetable

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

  function inpObj = BuildSignal_HVBatteryVoltage(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.HVBattV = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.HVBattV.Properties.VariableNames = {'HVBattV'};
    inpObj.HVBattV.Properties.VariableUnits = {'V'};
    inpObj.HVBattV.Properties.VariableContinuity = {'continuous'};
    inpObj.HVBattV = ...
      retime(inpObj.HVBattV, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_AxleSpeed_OnOff(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.AxleSpd_OnOff = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.AxleSpd_OnOff.Properties.VariableNames = {'AxleSpd_OnOff'};
    inpObj.AxleSpd_OnOff.Properties.VariableUnits = {'1'};
    inpObj.AxleSpd_OnOff.Properties.VariableContinuity = {'step'};
  end

  function inpObj = BuildSignal_AxleSpeed(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.AxleSpd = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.AxleSpd.Properties.VariableNames = {'AxleSpd'};
    inpObj.AxleSpd.Properties.VariableUnits = {'rpm'};
    inpObj.AxleSpd.Properties.VariableContinuity = {'continuous'};
    inpObj.AxleSpd = ...
      retime(inpObj.AxleSpd, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_AxleTorque(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.AxleTrq = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.AxleTrq.Properties.VariableNames = {'AxleTrq'};
    inpObj.AxleTrq.Properties.VariableUnits = {'N*m'};
    inpObj.AxleTrq.Properties.VariableContinuity = {'continuous'};
    inpObj.AxleTrq = ...
      retime(inpObj.AxleTrq, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_BrakeForce(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.BrkForce = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.BrkForce.Properties.VariableNames = {'BrkForce'};
    inpObj.BrkForce.Properties.VariableUnits = {'N'};
    inpObj.BrkForce.Properties.VariableContinuity = {'continuous'};
    inpObj.BrkForce = ...
      retime(inpObj.BrkForce, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function signalData = BundleSignals(inpObj)
  %%
    signalData.Signals.EngTrqCmd = inpObj.EngTrqCmd;
    signalData.Signals.Mg1TrqCmd = inpObj.Mg1TrqCmd;
    signalData.Signals.Mg2TrqCmd = inpObj.Mg2TrqCmd;
    signalData.Signals.HVBattV = inpObj.HVBattV;
    signalData.Signals.AxleSpd_OnOff = inpObj.AxleSpd_OnOff;
    signalData.Signals.AxleSpd = inpObj.AxleSpd;
    signalData.Signals.AxleTrq = inpObj.AxleTrq;
    signalData.Signals.BrkForce = inpObj.BrkForce;

    signalData.Bus = Simulink.Bus;
    sigs = {
      inpObj.EngTrqCmd, ...
      inpObj.Mg1TrqCmd, ...
      inpObj.Mg2TrqCmd, ...
      inpObj.HVBattV, ...
      inpObj.AxleSpd_OnOff, ...
      inpObj.AxleSpd, ...
      inpObj.AxleTrq, ...
      inpObj.BrkForce };
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
