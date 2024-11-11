%parseVariableFile Parse a file containing matlab variable assigments
%
%   parseVariableFile
%
%   Input variables:
%
%   fid         The file id of the file to parse, as returned by fopen
%
%
%   Output variables:
%
%   Anything defined in the file.
%
%
%   Internal variables:
%
%   All internal variables begin with pvf_ and are cleared at the end of
%   the scipt
%
%   parseVariableFile evaluates each non-empty, non-comment line in the
%   specified file.  If an error occurs evaluating the file then a message
%   and the bad line is printed and an error generated.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 22:22:11 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pvf_idxLine = 1;
pvf_line = fgetl(fid);
% The while chokes on a truly blank line
if isempty(pvf_line)
  pvf_line = ' ';
end
while pvf_line ~= -1
  if (~ isempty(pvf_line)) & (~ strncmp(pvf_line, '%', 1))
    try
      eval([pvf_line ';']);
    catch
      fprintf('\nUnable to evaluate line %d\n', pvf_idxLine)
      fprintf('%s\n', pvf_line);
      retVal = 1;
      error('Parameter file syntax error');
      return
    end
  end
  pvf_line = fgetl(fid);
  pvf_idxLine = pvf_idxLine + 1;
  if isempty(pvf_line)
    pvf_line = ' ';
  end
end
clear pvf_idxLine pvf_line
if PRINT_ID
    fprintf('$Id: parseVariableFile.m,v 1.2 2005/08/15 22:22:11 rickg Exp $\n');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: parseVariableFile.m,v $
%  Revision 1.2  2005/08/15 22:22:11  rickg
%  Added global print ID
%
%  Revision 1.1  2005/01/31 01:37:42  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%