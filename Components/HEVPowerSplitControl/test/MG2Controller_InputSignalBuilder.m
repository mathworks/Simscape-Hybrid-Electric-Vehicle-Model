classdef MG2Controller_InputSignalBuilder < handle
% Class implementation of Input Signal Builder

%{
PowerSplitHEV_params
HEVPowerSplitControl_params

mg2input = MG2Controller_InputSignalBuilder().SweepChargeLevel;
inputSignals = mg2input.Signals;
inputBus = mg2input.Bus;
%}

%{
mg2input = MG2Controller_InputSignalBuilder(Plot_tf=true).SweepChargeLevel;
%}

%{
in=InputSignalBuilder; in.Plot_tf=true; Input_Constant(in);
%}

%{
in=InputSignalBuilder; in.Plot_tf=true; Input_Pulse(in);
%}

% Copyright 2022 The MathWorks, Inc.

properties
  % ### Signals

  ChargeLevel timetable
  BrakeOn timetable
  AxleSpeed timetable
  AxleSpeedRef timetable

  % ### Other properties

  FunctionName (1,1) string
  StopTime (1,1) duration

  ParentFigure (1,1)  % must be of type matlab.ui.Figure
  Plot_tf (1,1) logical = false
  VisiblePlot_tf (1,1) logical = true
  FigureWidth (1,1) double = 500
  FigureHeight (1,1) double = 400
  LineWidth (1,1) double = 2

  SavePlot_tf (1,1) logical = false
  SavePlotImageFileName (1,1) {mustBeTextScalar} = "image_input_signals.png"
end

methods

  function inpObj = MG2Controller_InputSignalBuilder(nvpairs)
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
    Input_Constant(inpObj);

  end

  function plotSignals(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.ParentFigure (1,1)
    end

    syncedInputs = synchronize( ...
                      inpObj.ChargeLevel, ...
                      inpObj.BrakeOn, ...
                      inpObj.AxleSpeed, ...
                      inpObj.AxleSpeedRef );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.ChargeLevel), ...
      addUnitString(inpObj.BrakeOn), ...
      addUnitString(inpObj.AxleSpeed), ...
      addUnitString(inpObj.AxleSpeedRef) };

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

  %% Patterns

  function signalData = Input_Constant(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(1)
      nvpairs.ChargeLevel_Const (1,1) {mustBeInRange(nvpairs.ChargeLevel_Const, 0, 3)} = 2
      nvpairs.BrakeOn_Const (1,1) logical = false
      nvpairs.AxleSpeed_Const_rpm (1,1) double = 0
      nvpairs.AxleSpeedRef_Const_rpm (1,1) double = 0
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.ChargeLevel_Const;
    BuildSignal_ChargeLevel(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.BrakeOn_Const;
    BuildSignal_BrakeOn(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeed_Const_rpm;
    BuildSignal_AxleSpeed(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    x1 = nvpairs.AxleSpeedRef_Const_rpm;
    BuildSignal_AxleSpeedRef(inpObj, 'Data',[x1 x1]', 'Time',seconds([0 t_end]'));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

  function signalData = SweepChargeLevel(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(400)
      nvpairs.BrakeOn_Const (1,1) logical = false
      nvpairs.AxleSpeed_Const_rpm (1,1) double = 1000
      nvpairs.AxleSpeedRef_Const_rpm (1,1) double = 1000
    end

    % Record the function name for convenience.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    BuildSignal_ChargeLevel(inpObj, 'Data',[0 1 2 3 3], 'Time',seconds([0 100 200 300 t_end]));

    x1 = nvpairs.BrakeOn_Const;
    BuildSignal_BrakeOn(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.AxleSpeed_Const_rpm;
    BuildSignal_AxleSpeed(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.AxleSpeedRef_Const_rpm;
    BuildSignal_AxleSpeedRef(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

  end  % function

end  % methods

methods (Access = private)

  %% Build signal trace with timetable

  function inpObj = BuildSignal_ChargeLevel(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.ChargeLevel = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.ChargeLevel.Properties.VariableNames = {'ChargeLevel'};
    inpObj.ChargeLevel.Properties.VariableUnits = {'1'};
    inpObj.ChargeLevel.Properties.VariableContinuity = {'step'};
  end

  function inpObj = BuildSignal_BrakeOn(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.BrakeOn = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.BrakeOn.Properties.VariableNames = {'BrakeOn'};
    inpObj.BrakeOn.Properties.VariableUnits = {'1'};
    inpObj.BrakeOn.Properties.VariableContinuity = {'step'};
  end

  function inpObj = BuildSignal_AxleSpeed(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.AxleSpeed = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.AxleSpeed.Properties.VariableNames = {'AxleSpeed'};
    inpObj.AxleSpeed.Properties.VariableUnits = {'rpm'};
    inpObj.AxleSpeed.Properties.VariableContinuity = {'continuous'};
    inpObj.AxleSpeed = ...
      retime(inpObj.AxleSpeed, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_AxleSpeedRef(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.AxleSpeedRef = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.AxleSpeedRef.Properties.VariableNames = {'AxleSpeedRef'};
    inpObj.AxleSpeedRef.Properties.VariableUnits = {'rpm'};
    inpObj.AxleSpeedRef.Properties.VariableContinuity = {'continuous'};
    inpObj.AxleSpeedRef = ...
      retime(inpObj.AxleSpeedRef, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function signalData = BundleSignals(inpObj)
  %%
    signalData.Signals.ChargeLevel = inpObj.ChargeLevel;
    signalData.Signals.BrakeOn = inpObj.BrakeOn;
    signalData.Signals.AxleSpeed = inpObj.AxleSpeed;
    signalData.Signals.AxleSpeedRef = inpObj.AxleSpeedRef;

    signalData.Bus = Simulink.Bus;
    sigs = {
      inpObj.ChargeLevel
      inpObj.BrakeOn
      inpObj.AxleSpeed
      inpObj.AxleSpeedRef };
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
