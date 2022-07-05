function tf = isNewerFileDateTime(file1, file2)
%% Checks if file1 is newer than file2.

% Copyright 2022 The MathWorks, Inc.

f1 = dir(file1);
f2 = dir(file2);
tf = datetime(f1.date) > datetime(f2.date);

end
