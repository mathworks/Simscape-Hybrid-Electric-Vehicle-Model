classdef Engine_InputSignalBuilder < handle
% Class implementation of Input Signal Builder

% Copyright 2022 The MathWorks, Inc.

% You can run this class by selecting the following code
% and pressing the F9 key.
%{
engineInputData = Engine_InputSignalBuilder().Input_Constant;
engineInput_Signals = engineInputData.Signals;
engineInput_Bus = engineInputData.Bus;
%}

properties
  % ### Signals

  EngTrqCmd timetable
  MG1TrqCmd timetable
  BrkForce timetable

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

  function inpObj = Engine_InputSignalBuilder(nvpairs)
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
                      inpObj.MG1TrqCmd, ...
                      inpObj.BrkForce );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.EngTrqCmd), ...
      addUnitString(inpObj.MG1TrqCmd), ...
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
      nvpairs.EngineTorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 100
      nvpairs.MG1TorqueCommand_Const_Nm (1,1) = 20
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

    x1 = nvpairs.BrakeForce_Const_N;
    BuildSignal_BrakeForce(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = Step(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
      nvpairs.MG1TorqueCommand_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.Torque_1_Nm (1,1) {mustBeNonnegative} = 100
      nvpairs.Torque_2_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.ChangeStartTime duration = seconds(50)
      nvpairs.ChangeEndTime duration = seconds(50 + 1)
      nvpairs.StopTime (1,1) duration = seconds(51 + 149)
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.Torque_1_Nm;
    x2 = nvpairs.Torque_2_Nm;

    t1 = seconds(nvpairs.ChangeStartTime);
    t2 = seconds(nvpairs.ChangeEndTime);
    assert(0.1 < t1)
    assert(t1 < t2)
    assert(t2+0.1 < t_end)

    BuildSignal_EngineTorqueCommand(inpObj, ...
      'Data',        [x1 x1  x1 x2 x2     x2]', ...
      'Time',seconds([ 0 0.1 t1 t2 t2+0.1 t_end]'));

    x1 = nvpairs.MG1TorqueCommand_Const_Nm;
    BuildSignal_MG1TorqueCommand(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.BrakeForce_Const_N;
    BuildSignal_BrakeForce(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

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
    inpObj.MG1TrqCmd = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.MG1TrqCmd.Properties.VariableNames = {'MG1TrqCmd'};
    inpObj.MG1TrqCmd.Properties.VariableUnits = {'N*m'};
    inpObj.MG1TrqCmd.Properties.VariableContinuity = {'continuous'};
    inpObj.MG1TrqCmd = ...
      retime(inpObj.MG1TrqCmd, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
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
    signalData.Signals.MG1TrqCmd = inpObj.MG1TrqCmd;
    signalData.Signals.BrkForce = inpObj.BrkForce;

    signalData.Bus = Simulink.Bus;
    sigs = {
      inpObj.EngTrqCmd, ...
      inpObj.MG1TrqCmd, ...
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
