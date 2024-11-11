%saveMOTL       Save a motive list to a file
%
%   motiveList  The motive list to be saved
%
%   filename    The filename to save it to.

function saveMOTL(motiveList, filename)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: saveMOTL.m,v 1.3 2005/08/15 23:17:37 rickg Exp $\n');
end

tom_emwrite(filename, tom_emheader(motiveList));