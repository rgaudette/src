%findSelected Return the align structure indices above a threshold, ordered
%
%   idxSelected = findSelected(alignStruct, threshold, debugLevel)
%
%   alignStruct The alignment structure to process.
%
%   threshold   The threshold used to select the particles by their similarity
%               measure or if >=1 then the number of particles to select
%
%   debugLevel  diagnostic test printing
%
%   findSelected will return the indices of the align structure entries that are
%   greater than the threshold if the threshold is < 1.  Or the specified number
%   of particles if threshold is >= 1.  The indices are returned in sorted order
%   so that incremental averaging can be easily implemented.
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

function idxSelected = findSelected(alignStruct, threshold, debugLevel)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: findSelected.m,v 1.4 2005/08/15 23:17:36 rickg Exp $\n');
end

% If the threshold is > 1 sort the cross correlation coefficient to find
% the appropriate threshold
[CCCsort idxSort]= sort(alignStruct(1,:), 2, 'descend');
if threshold >= 1
  threshold = CCCsort(threshold) - eps;
  if threshold < 0
    threshold = 0;
  end

  if debugLevel > 1
    fprintf('Using similarity threshold of: %f\n', threshold);
  end
end

% Return the selected indicies in sorted order so that incremental averages can
% be implemented
idxSelected = idxSort(CCCsort > threshold);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: findSelected.m,v $
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
