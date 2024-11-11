%MEANTHR        Mean threshold a vector.
%
%   [y vecSelect] = meanthr(x, nBlank, nWindow, Threshold)
%
%   Y           The threshold vector.   Only those elements that are above
%               their threshold are returned, all others are set to zero.
%               y has the same dimensions as x.
%
%   vecSelect   A binary vector identifying which elements are above their
%               thresholds.
%
%   x           The vector to be thresholded.
%
%   nBlank      The number of elements to blank around the element being
%               tested.  These elements are not included in the averaging to
%               detemine the threshold.
%
%   nWindow     The number of elements to average on either side of the
%               blanking window.  Thus the total number of elements averaged
%               is 2 x nWindow.
%
%   Threshold   The amount to scale the average computed by to create the
%               threshold level.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: meanthr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:06:35  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y, vecSelect] = meanthr(x, nBlank, nWindow, Threshold)

%%
%%  Check calling arguments
%%
if nargin ~= 4,
    error('Wrong number of arguments');
end

%%
%%  Intializations
%%
[nrX ncX] = size(x);
if nrX == 1,
    x = x(:);
    flgTransposeOutput = 1;
    nSamples = ncX;
elseif ncX == 1,
    flgTransposeOutput = 0;
    nSamples = nrX;
else
    error('Input sequence must be a vector');
end

y = zeros(nSamples, 1);
window = [ones(nWindow, 1); zeros(nBlank, 1); ones(nWindow, 1)];
nFilter = 2 * nWindow + nBlank;


%%
%%  Window data creating a threshold seqeunce
%%
nOut = nSamples - nFilter + 1;
ThreshVec = zeros(nOut, 1);
for iOut = 1:nOut,
    ThreshVec(iOut) = sum(x(iOut:iOut+nFilter-1) .* window) ./ (2*nWindow);
end

%%
%%  Scale the shifted threshold vector compare to input vector.
%%
vecSelect = zeros(nSamples,1);
nShift = nWindow + floor(nBlank/2);
xvalid = x(nShift:nShift+nOut-1);
vecSelect(nShift:nShift+nOut-1) =  xvalid > (ThreshVec * Threshold);
y = x .* vecSelect;

%%
%%  Transpose the output vector if necessary
%%
if flgTransposeOutput,
    y = y.';
    vecSelect = vecSelect';
end

