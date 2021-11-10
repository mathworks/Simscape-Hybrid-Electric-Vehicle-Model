% This script is automatically run when the MATLAB Project is opened.
% To change the automatic execution setting, select the Project window,
% and in the PROJECT toolstrip, click Startup Shutdown button.
%
% Copyright 2020-2021 The MathWorks, Inc.

if not(contains(string(ver('matlab').Release), "R2021a"))
  disp("This project was developed in R2021a.")
  releaseStr = ver('matlab').Release;
  disp("This MATLAB Release is " + releaseStr(2:end-1) + ".")
  clear release
end
