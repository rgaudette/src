%deleteExcluded Prevent the use of excluded particles in an align structure
%
%   alignStruct = deleteExcluded(alignStruct, excludeList)
%
%   alignStruct The alignment structure to process.
%
%   exludeList  The inidices of the particles to be excluded.
%
%   deleteExcluded will set all entries of the alignStruct to -Inf so the
%   particles are not used.
%
%   Calls: 
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function alignStruct = deleteExcluded(alignStruct, excludeList)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: deleteExcluded.m,v 1.4 2005/08/15 23:17:36 rickg Exp $\n');
end

% Remove any excluded entries from consideration since we don't want to
% reorder the original align structure we set all of the entries for the
% entries to -Inf
if ~isempty(excludeList)
  idxExclude = zeros(1, size(alignStruct, 2));
  idxExclude(excludeList) = 1;
  alignStruct(:, logical(idxExclude)) = -Inf;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: deleteExcluded.m,v $
%  Revision 1.4  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.3  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.2  2005/07/12 20:10:04  rickg
%  ClassID, include and exclude lists implemented
%
%  Revision 1.1  2005/03/27 17:39:18  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
