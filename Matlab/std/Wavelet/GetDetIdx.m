%GetDetIdx      Get the elements or indices of a given scale detail sequence.
%
%   cdet = GetDetIdx(cmap, iScale, w)
%   idx = GetDetIdx(cmap. iScale)
%
%   cdet        The detail coefficient.
%
%   idx         The index of the detail coefficients within w.
%
%   cmap        The coefficient map from dwt, dwtz, or dwtp.
%
%   iScale      The scale to be extracted. 
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: GetDetIdx.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = GetDetIdx(cmap, iScale, w)

idxStart = cumsum([1; cmap]);
idxStop = cumsum(cmap);
if nargin < 3
    result = idxStart(iScale):idxStop(iScale);
else
    result = w(idxStart(iScale):idxStop(iScale));
end
