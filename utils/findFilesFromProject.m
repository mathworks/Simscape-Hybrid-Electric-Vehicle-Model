function result = findFilesFromProject(filenamepart)
%% Returns file paths that include the specified string

arguments
  filenamepart {mustBeTextScalar} = ""
end

% This function assumes that a MATLAB Project is loaded.
prj = currentProject;

prjfiles = [prj.Files(:).Path]';

lix = contains(prjfiles, filenamepart);

result = prjfiles(lix);

end
