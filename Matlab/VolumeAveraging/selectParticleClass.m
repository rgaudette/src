%selectParticleClass  Select the particles in an alignment structure by class ID
%
%   alignStruct = selectParticleClass(alignStruct, lstClassID)
%
%   alignStruct The alignment structure to process.
%
%   lstClassID  The class IDs to include in the alignment structure.
%
%   selectParticleClass will search through an alignment structure including any
%   entries that have a classID matching a value in lstClassID.
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

function alignStruct = selectParticleClass(alignStruct, lstClassID)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: selectParticleClass.m,v 1.3 2005/08/15 23:17:37 rickg Exp $\n');
end

% create a logical vector indicating which particles to select
nParticles = size(alignStruct, 2);
select = logical(zeros(1, nParticles));

for idClass = lstClassID
  select = select | (alignStruct(20, :) == idClass);
end

% Invert the vector and excluded the entries from consideration since we don't
% want to reorder the original align structure we set all of the entries for the
% entries to -Inf
alignStruct(:, ~ select) = -Inf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: selectParticleClass.m,v $
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
