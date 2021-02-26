% This script is automatically run when the MATLAB Project is opened.
% To chagne the automatic execution setting, select the Project window, and in
% the PROJECT toolstrip, click Startup Shutdown button.
%
% Copyright 2020-2021 The MathWorks, Inc.

v = ver('matlab');
if not(v.Version == "9.9")
  release = "R2020b";
  disp("This project was developed in " + release + ",")
  disp("This MATLAB is " + v.Release(2:end-1) + ".")
  clear release
end
clear v
