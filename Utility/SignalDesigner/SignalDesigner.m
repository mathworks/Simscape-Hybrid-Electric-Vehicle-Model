classdef SignalDesigner < handle
%% Signal Designer class implementation

% Copyright 2022 The MathWorks, Inc.

properties
  % Signal specifications

  Type {mustBeMember(Type, ["step", "continuous", "timedstep", "timedcontinuous"])} = "step"

  Title {mustBeTextScalar} = ""
  Description {mustBeTextScalar} = ""

  XName {mustBeTextScalar} = "X"
  XVarName {mustBeTextScalar} = "X"
  XUnit {mustBeTextScalar} = "1"

  YName {mustBeTextScalar} = "Y"
  YVarName {mustBeTextScalar} = "Y"
  YUnit {mustBeTextScalar} = "1"

  XYData double

  % For continuous data
  DeltaX (1,1) double {mustBePositive} = 0.1

  % For timed data
  XDurationHandle (1,1) function_handle = @seconds

  % Properties for saving signal spec
  SpecFilename {mustBeTextScalar} = ""
  XSaveFormat {mustBeTextScalar} = "%0.2f"
  YSaveFormat {mustBeTextScalar} = "%0.4f"

  % ----- Internally generated properties -----

  TransformedData table
  Data table

  % For timed data
  TimedData timetable

  % For continous data
  XRefined (:,1) double
  YRefined (:,1) double
  InterpolatedData table

end  % properties

methods
%%


function sigObj = SignalDesigner(SignalType)
%%

arguments
  SignalType {mustBeMember(SignalType, ["step", "continuous", "timedstep", "timedcontinuous"])} = "step"
end

sigObj.Type = SignalType;

if sigObj.Type == "step" || sigObj.Type == "timedstep"
  sigObj.XYData = [ 0 1 ; 1 2 ; 2 0 ; 3 0 ];
else  % continuous or timedcontinuous
  sigObj.XYData = [ 0 1 1 ; 2 3 2 ];
end

update(sigObj);

end  % function


function update(sigObj)
%%

arguments
  sigObj (1,1) SignalDesigner
end

if sigObj.Type == "timedstep" || sigObj.Type == "timedcontinuous"
  % X variable is set to Time.
  sigObj.XName = "Time";
  sigObj.XVarName = "Time";

  % Use seconds for the default unit of time.
  sigObj.XUnit = "s";
  sigObj.XDurationHandle = @seconds;
end

if sigObj.Type == "step" || sigObj.Type == "timedstep"
  % sigObj.Data = transformDataPoints(sigObj, sigObj.XYData);

  % Check X data points
  xPoints = sigObj.XYData(:, 1);
  assert( issorted(xPoints, "strictascend"), ...
    "SignalDesigner: X must be strictly asending.")

  % Check Y data points
  yPoints = sigObj.XYData(:, 2);
  assert( all(not(isnan(yPoints))), ...
    "SignalDesigner: Y start data points cannot have NaN.")

  % Build data
  newData = table(xPoints, yPoints);
  newData.Properties.VariableNames = [sigObj.XVarName, sigObj.YVarName];
  newData.Properties.VariableUnits = [sigObj.XUnit, sigObj.YUnit];
  sigObj.Data = newData;

else  % continuous or timedcontinuous
  sigObj.TransformedData = transformDataPoints(sigObj, sigObj.XYData);
  sigObj.InterpolatedData = interpolateDataPoints(sigObj, sigObj.TransformedData);
  sigObj.Data = eliminateRedundantDataPoints(sigObj, sigObj.InterpolatedData);

end  % if

end  % function


function fig = plotDataPoints(sigObj, nvpairs)
%% Plots generated data points.

arguments
  sigObj (1,1) SignalDesigner
  nvpairs.SimplePlot (1,1) logical = true
end

update(sigObj);

plotMore = not(nvpairs.SimplePlot);

fig = figure;
fig.Position(3:4) = [800 400];
hold on
grid on
axis padded

if sigObj.Title ~= ""
  title(sigObj.Title)
end

if sigObj.Type == "step" || sigObj.Type == "timedstep"
  st = stairs(sigObj.Data, sigObj.XVarName, sigObj.YVarName);
  st.LineWidth = 2;

  sc = scatter(sigObj.Data, sigObj.XVarName, sigObj.YVarName);
  sc.Marker = "o";
  sc.SizeData = 36*2;
  sc.LineWidth = 2;

  legend(["Generated signal trace", "User data"], Location="best")

else  % continuous or timedcontinuous
  if plotMore
    % Simply interpolated points
    sc = scatter(sigObj.InterpolatedData.(sigObj.XVarName), sigObj.InterpolatedData.(sigObj.YVarName), 36*1);
    sc.Marker = "x";
    sc.LineWidth = 1;

    % Interpolated points without redundancy
    sc = scatter(sigObj.Data.(sigObj.XVarName), sigObj.Data.(sigObj.YVarName), 36*3);
    sc.Marker = "+";
    sc.LineWidth = 1.5;

    % User data
    lix = sigObj.TransformedData.Added == false;  % logical index
    xTmp = sigObj.TransformedData.X;
    yTmp = sigObj.TransformedData.Y;
    sc = scatter(xTmp(lix), yTmp(lix), 36*4);
    sc.Marker = "o";
    sc.LineWidth = 2;

    legend(["Interpolated", "Final data", "User data"], Location="best")
  else
    % Interpolated points without redundancy
    plot(sigObj.Data.(sigObj.XVarName), sigObj.Data.(sigObj.YVarName), LineWidth=2);

    % User data
    lix = sigObj.TransformedData.Added == false;  % logical index
    xTmp = sigObj.TransformedData.X;
    yTmp = sigObj.TransformedData.Y;
    sc = scatter(xTmp(lix), yTmp(lix), 36*1.5);
    sc.Marker = "o";
    sc.LineWidth = 2;

    legend(["Generated signal trace", "Data points"], Location="best")
  end

end  % if

xLabelStr = sigObj.XName;
if sigObj.Data.Properties.VariableUnits(1) ~= "1"
  xLabelStr = xLabelStr + " (" + sigObj.Data.Properties.VariableUnits(1) + ")";
end
xlabel(xLabelStr)

yLabelStr = sigObj.YName;
if sigObj.Data.Properties.VariableUnits(2) ~= "1"
  yLabelStr = yLabelStr + " (" + sigObj.Data.Properties.VariableUnits(2) + ")";
end
ylabel(yLabelStr)

end  % function


function saveSpec(sigObj, SpecFilename)
%% Saves signal specification to JSON file.

arguments
  sigObj (1,1) SignalDesigner
  SpecFilename {mustBeTextScalar}
end

% SpecFilename is saved to sigObj. saveData function uses it.
sigObj.SpecFilename = SpecFilename;

signalSpec = [];
signalSpec.Type = sigObj.Type;
signalSpec.Title = sigObj.Title;
signalSpec.Description = sigObj.Description;
signalSpec.XName = sigObj.XName;
signalSpec.XVarName = sigObj.XVarName;
signalSpec.XUnit = sigObj.XUnit;
signalSpec.YName = sigObj.YName;
signalSpec.YVarName = sigObj.YVarName;
signalSpec.YUnit = sigObj.YUnit;
signalSpec.XSaveFormat = sigObj.XSaveFormat;
signalSpec.YSaveFormat = sigObj.YSaveFormat;
if sigObj.Type == "continuous" || sigObj.Type == "timedcontinuous"
  signalSpec.DeltaX = sigObj.DeltaX;
end
signalSpec.XYData = sigObj.XYData;

jsonStr = string(jsonencode(signalSpec, PrettyPrint=true));

% The above jsonStr can be saved to file, but
% each element of a row is placed in separate lines
% with many unnecessary white spaces due to the PrettyPrint=true option.
% The code below combine those lines to a more compact yet readable style.
jsonStrFirstPart = extractBefore(jsonStr, newline + whitespacePattern + "[" + newline) + newline;

if sigObj.Type == "step" || sigObj.Type == "timedstep"
  ptn = whitespacePattern + "[" + newline ...
    + whitespacePattern + digitsPattern + "," + newline ... x
    + whitespacePattern + digitsPattern + newline;   % y

else
  ptn = whitespacePattern + "[" + newline ...
    + whitespacePattern + digitsPattern + "," + newline ... x1
    + whitespacePattern + (digitsPattern | caseInsensitivePattern("null")) + "," + newline ... x2
    + whitespacePattern + digitsPattern + newline;  % y

end  % if

jsonStrDataPoints = extract(jsonStr, ptn);
jsonStrDataPoints = erase(jsonStrDataPoints, [newline whitespacePattern]) + "]," + newline;
jsonStrDataPoints(end) = replace(jsonStrDataPoints(end), "],", "]");

% join uses a white space as a default delmiter, which
% we don't need, thus specifying "" in the second argument.
jsonStrDataPoints = join(jsonStrDataPoints, "");

jsonStr = jsonStrFirstPart + jsonStrDataPoints + "]}";

fid = fopen(SpecFilename, "w");
fprintf(fid, "%s", jsonStr);
fclose(fid);

end  % function


function specStruct = loadSpec(sigObj, SpecFilename)
%% Reads signal spec file and updates signal object.

arguments
  sigObj (1,1) SignalDesigner
  SpecFilename {mustBeTextScalar}
end

jsonStr = fileread(SpecFilename);

specStruct = jsondecode(jsonStr);

% JSON supports fewer data types than MATLAB.
% For example, string in MATLAB is saved as charactor vector in JSON
% because there is no string type in JSON.
% thus jsondecode returns charactor vector for texts.
% You must convert them to string explicitly if necessary.

sigObj.Type = string(specStruct.Type);
sigObj.Title = string(specStruct.Title);
sigObj.Description = string(specStruct.Description);
sigObj.XName = string(specStruct.XName);
sigObj.XVarName = string(specStruct.XVarName);
sigObj.XUnit = string(specStruct.XUnit);
sigObj.YName = string(specStruct.YName);
sigObj.YVarName = string(specStruct.YVarName);
sigObj.YUnit = string(specStruct.YUnit);
sigObj.SpecFilename = string(SpecFilename);

if sigObj.Type == "continuous" || sigObj.Type == "timedcontinuous"
 sigObj.DeltaX = specStruct.DeltaX;
end

end  % function


function saveData(sigObj, DataFilename)
%% Saves generated signal data to M file.

arguments
  sigObj (1,1) SignalDesigner
  DataFilename {mustBeTextScalar}
end

xDataStr = sprintf(sigObj.XSaveFormat + " ", sigObj.Data.(sigObj.XVarName));
xDataStr = "[ " + xDataStr + "]";

yDataStr = sprintf(sigObj.YSaveFormat + " ", sigObj.Data.(sigObj.YVarName));
yDataStr = "[ " + yDataStr + "]";

dataStr = ...
  "% " + sigObj.Description + newline + ...
  "% X: " + sigObj.XName + " (" + sigObj.XUnit + ")" + newline + ...
  "% Y: " + sigObj.YName + " (" + sigObj.YUnit + ")" + newline + ...
  "% Spec file: " + sigObj.SpecFilename + newline + ...
  sigObj.XVarName + " = " + xDataStr + ";" + newline + ...
  sigObj.YVarName + " = " + yDataStr + ";" + newline;

fid = fopen(DataFilename, "w");
fprintf(fid, "%s", dataStr);
fclose(fid);

end  % function


function timedData = buildTimedData(sigObj, data)
%% Builds timetable data from table data.

arguments
  sigObj (1,1) SignalDesigner
  data table
end

assert( sigObj.Type ~= "step", ...
  "SignalDesigner: Signal of type step cannot be converted to timed data." )

assert( sigObj.Type ~= "continuous", ...
  "SignalDesigner: Signal of type continuous cannot be converted to timed data." )

timeVector = sigObj.XDurationHandle( data.(sigObj.XVarName) );

timedData = timetable( data.(sigObj.YVarName), RowTime = timeVector );

timedData.Properties.VariableNames(1) = sigObj.YVarName;
timedData.Properties.VariableUnits(1) = sigObj.YUnit;

% Variable continuity is specific to timetable. Table does not have it.
if sigObj.Type == "timedstep"
  timedData.Properties.VariableContinuity = "step";
else
  timedData.Properties.VariableContinuity = "continuous";
end

end  % function


function [dataStruct, dataBus] = setupForFromWorkspaceBlock(sigObj)
%% Sets up variables for use in From Workspace block in Simulink

arguments
  sigObj (1,1) SignalDesigner
end

assert( sigObj.Type ~= "step", ...
  "SignalDesigner: Signal of type step cannot be converted to timed data." )

assert( sigObj.Type ~= "continuous", ...
  "SignalDesigner: Signal of type continuous cannot be converted to timed data." )

sigObj.TimedData = buildTimedData(sigObj, sigObj.Data );

dataStruct.(sigObj.YVarName) = sigObj.TimedData;

dataBus = Simulink.Bus;
dataBus.Elements = Simulink.BusElement;
dataBus.Elements(1).Name = sigObj.TimedData.Properties.VariableNames{1};
dataBus.Elements(1).Unit = sigObj.TimedData.Properties.VariableUnits{1};

end  % function


function result = transformDataPoints(~, xyData)
%% Transforms compact xy-data points to a format suitable for processing
% Converts a row in [x1 x2 y] format into [x1 y; x2 y] format.
% Optionally adds mid-points for smoothing.
% Works with continuous and timedcontinuous cases.

arguments
  ~

  % N-by-3 matrix. Each row is [x1 x2 y].
  % x1 is X start data point.
  % x2 is X end data point, which can be nan.
  % y is Y data point.
  xyData (:,3) double
end

numInputRows = height(xyData);

% Check X data points

xPoints = xyData(:, [1 2]);

assert(issorted(xPoints(:,1), "strictascend"), ...
  "SignalDesigner: X start vector must be strictly asending.")

tmpVec = xPoints(:,2);
lix = not(isnan(tmpVec));  % logical index
if any(lix)
  tmpVec = tmpVec(lix);
  assert(issorted(tmpVec, "strictascend"), ...
    "SignalDesigner: X end vector must be strictly asending.")

  dx = xPoints(:,2) - xPoints(:,1);

  cond_dx_is_nan = isnan(dx);
  cond_dx_is_pos = dx > 0;
  violating = not(cond_dx_is_nan | cond_dx_is_pos);
  lix = find(violating);  % logical index
  assert(isempty(lix), ...
    "SignalDesigner: X start is after X end, which is invalid, at these rows: " + num2str(lix'));

end  % if

% Check Y data points

yPoints = xyData(:, 3);

assert(all( not(isnan( yPoints )) ), ...
  "SignalDesigner: Y start data points cannot have NaN.")

% Build data

% If transformedData.Refine(i) is true,
% apply interpolation to the data between i and i+1.
transformedData = struct('X', [], 'Y',[], 'Added',[], 'Refine',[]);

idx = 1;
for r = 1 : numInputRows

  % xp(1) is X start point. Must exist.
  % xp(2) is X end point. May not exist.
  % yp is Y data point. Must exist.
  xp = xPoints(r, :);
  yp = yPoints(r);

  transformedData(idx).X = xp(1);
  transformedData(idx).Y = yp;
  transformedData(idx).Added = false;
  transformedData(idx).Refine = false;

  idx = idx + 1;

  if isnan(xp(2))
    % X end point, xp(2), is not defined.
    % This point is used for interpolation.

    transformedData(idx-1).Refine = true;

  else
    % X end point, xp(2), is defined.
    % This point is part of flat segment and not used for interpolation.

    % Add mid-point.
    transformedData(idx).Added = true;
    transformedData(idx).X = (xp(1) + xp(2)) / 2;
    transformedData(idx).Y = yp;
    transformedData(idx).Refine = false;

    idx = idx + 1;

    % Add end point.
    transformedData(idx).Added = false;
    transformedData(idx).X = xp(2);
    transformedData(idx).Y = yp;
    transformedData(idx).Refine = true;

    idx = idx + 1;

  end  % if
end  % for
transformedData(end).Refine = false;

dx = diff([transformedData.X]);
assert(all(dx > 0), "SignalDesigner: X data points are not strictly ascending.")

result = struct2table(transformedData);

end  % function


function result = interpolateDataPoints(sigObj, transformedData)
%% Interpolates data points.
% This takes transformed data points, not a user-specified matrix.

arguments
  sigObj (1,1) SignalDesigner
  transformedData (:,4)
end

x_1 = transformedData.X(1);
x_end = transformedData.X(end);
x_delta = sigObj.DeltaX;

% Check that delta x makes sense for interpolation.
% This check must be made in interpolating segments only.
indices = find(transformedData.Refine == true);
nextElementIndices = indices + 1;
x_refine = transformedData.X;
dx = x_refine(nextElementIndices) - x_refine(indices);
assert(x_delta <= min(dx)/2, ...
  "SignalDesigner: Delta X must be smaller than the half of min(dx) in interpolating segments.")

x_refined = transpose(x_1 : x_delta : x_end);

y_refined = interp1(transformedData.X, transformedData.Y, x_refined, "makima");

sigObj.XRefined = x_refined;
sigObj.YRefined = y_refined;

interpolatedData = table(x_refined, y_refined);
interpolatedData.Properties.VariableNames = [sigObj.XVarName sigObj.YVarName];
interpolatedData.Properties.VariableUnits = [sigObj.XUnit sigObj.YUnit];

result = interpolatedData;

end  % function


function result = eliminateRedundantDataPoints(sigObj, interpolatedData)
%% Eliminates redundant data points generated by interpolation.

arguments
  sigObj (1,1) SignalDesigner
  interpolatedData (:,2) table
end

newData = table(Size=[0, 2], VariableTypes=["double", "double"]);
newData.Properties.VariableNames = [sigObj.XVarName sigObj.YVarName];
newData.Properties.VariableUnits = [sigObj.XUnit sigObj.YUnit];

idx = 1;
while idx < height(sigObj.TransformedData) - 1

  if sigObj.TransformedData.Refine(idx) == true
    % Use interpolated points.
    xRange = (sigObj.TransformedData.X(idx) <= sigObj.XRefined) ...
              & (sigObj.XRefined <= sigObj.TransformedData.X(idx+1));
    % Avoid duplicating the same row.
    newData = [newData(1:end-1, :); interpolatedData(xRange, :)];
    idx = idx + 1;

  else
    % Interpolated points contain redundant points in flat segments.
    % Avoid including those redundant points.

    % We must skip the internally added mid-point.
    % Thus, idx+2 rather than idx+1 is used.
    tmpData = table( ...
                [sigObj.TransformedData.X(idx); sigObj.TransformedData.X(idx+2)], ...
                [sigObj.TransformedData.Y(idx); sigObj.TransformedData.Y(idx+2)], ...
                VariableNames = [sigObj.XVarName, sigObj.YVarName] );
    tmpData.Properties.VariableUnits = [sigObj.XUnit, sigObj.YUnit];

    % Avoid duplicating the same row.
    newData = [newData(1:end-1, :); tmpData];
    idx = idx + 2;

  end
end

assert(issorted(newData.(sigObj.XVarName), "strictascend"), ...
  "SignalDesigner: Generated data are not strictly asending.")

result = newData;

end  % function

end  % methods

end  % classdef
