function openProjectMainHTMLFile(filename)
% Opens the project main HTML file.

% Copyright 2023 The MathWorks, inc.

arguments
  filename (1,1) string = "HEVProject_main_script.html"
end

web(filename)

end  % function
