function checkMATLABReleaseMatch(DevelopedRelease)
% This script is automatically run when the MATLAB Project is opened.
% To change the automatic execution setting, navigate to the Project tab
% in the toolstrip, and click Startup Shutdown button.
%
% Copyright 2020-2023 The MathWorks, Inc.

arguments
  DevelopedRelease {mustBeTextScalar} = "R2023a"
end

if not(contains(string(ver('matlab').Release), DevelopedRelease))
  disp("This project was developed in " + DevelopedRelease + ".")
  thisMATLABRelease = ver('matlab').Release;
  disp("This MATLAB Release is " + thisMATLABRelease(2:end-1) + ".")
end

end  % function
