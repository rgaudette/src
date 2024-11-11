%MALLATRC       Process plaque data in 2D using Mallat's algorithm.
%
%    [RDecomp CDecomp] = mallatrc(Data, RScale, CScale, szArray)
%
%    RDecomp     Row-wise decomposed data.
%
%    CDecomp     Column-wise decomposed data.
%
%    Data        The data to decompose.  Each column should be a unique
%                time instant.
%
%    RScale      The scale to compute for the row decomposition.
%
%    CScale      The scale to compute for the column decomposition.
%
%    szArray     [OPTIONAL] The size of the electrode array.  If this is
%                not supplied a square array is assumed, this should be a
%                two element vector in the form [nRows nCols].
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:40 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mallatrc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:40  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 16:54:53  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [RDecomp, CDecomp] = mallatrc(Data, RScale, CScale, szArray)

%%
%%  Initializations
%%
[nLeads nSamples] = size(Data);
if nargin < 5
    nRows = sqrt(nLeads);
    nCols = nLeads / nRows;
    if nCols~= nRows,
        error('Lead array size not specified & data not square.');
    end
else
    nRows = szArray(1);
    nCols = szArray(2);
end

%%
%%  Decompose data across rows & down columns simultaneously.
%%
RDecomp = zeros(size(Data));
CDecomp = zeros(size(Data));

for iSamp = 1:nSamples

    %%
    %%  Extract the current sample matrix
    %%
    Array = reshape(Data(:,iSamp), nRows, nCols);

    temp = mallat1s(Array, CScale);
    CDecomp(:,iSamp) = temp(:);

    temp = mallat1s(Array', RScale)';
    RDecomp(:,iSamp) = temp(:);
end
