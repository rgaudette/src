%selectIncluded Select the list of included particles in an align structure
%
%   alignStruct = selectIncluded(alignStruct, idxInclude)
%
%   alignStruct The alignment structure to process.
%
%   idxInclude  The inidices of the particles to be included.
%
%   selectIncluded will set all entries of the alignStruct to -Inf so the
%   particles are not used.
%
%   Calls: 
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:37 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function alignStruct = selectIncluded(alignStruct, idxInclude)
global PRINT_ID
if PRINT_ID
    fprintf('$Id: selectIncluded.m,v 1.3 2005/08/15 23:17:37 rickg Exp $\n');
end

% create a logical vector indicating which particles to deselect
nParticles = size(alignStruct, 2);
deselect = ones(1, nParticles);
deselect(idxInclude) = 0;

% Remove any excluded entries from consideration since we don't want to
% reorder the original align structure we set all of the entries for the
% entries to -Inf
alignStruct(:, logical(deselect)) = -Inf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: selectIncluded.m,v $
%  Revision 1.3  2005/08/15 23:17:37  rickg
%  Type fix
%
%  Revision 1.2  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.1  2005/07/12 20:10:04  rickg
%  ClassID, include and exclude lists implemented
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
