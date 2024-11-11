%MALL3DF         Process plaque data in 3D using a forward diff Mallat's alg.
%
%   [TDecomp RDecomp CDecomp] = mall3df(Data, szArray, TScale, RScale, CScale)
%
%   TDecomp     Temporally decomposed data.
%
%   RDecomp     Row-wise decomposed data.
%
%   CDecomp     Column-wise decomposed data.
%
%   Data        The data to decompose.  Each column should be a unique
%                time instant.
%
%   szArray     This should be a two element vector in the form [nRows nCols].
%
%   TScale      The scale to compute for the temporal decomposition.
%
%   RScale      [OPTIONAL] The scale to compute for the row decomposition.
%
%   CScale      [OPTIONAL] The scale to compute for the column decomposition.
%
%   flgInterp   [OPTIONAL] Interpolate the spatial decompositions.
%
%
%   MALL3DF is derived MALL3D.  The direction of the data is reversed so that
%   a forward difference instead of a backward difference is computed.  The
%   sign of the details sequence is also changed so that it will coincide
%   with the true derivative.
%
%   Calls: mallat1s
%
%   Bugs:
%       - Mallat's paper describes a 2D joint smoothing in the spatial domain
%       This algorithm does not yet implement that.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:40 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mall3df.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:40  rickg
%  Matlab Source
%
%  Revision 1.3  1997/07/31 16:52:35  rjg
%  Unfixed previous bug.  Flipping data along columns is not necessary
%  because the operational sense is down the columns where as the spatial
%  sense (increasing y value is up the columns).
%
%  Revision 1.2  1997/04/09 15:07:56  rjg
%  Fixed bug that did not perform forward difference down columns.
%
%  Revision 1.1  1997/03/26 19:08:19  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [TDecomp, RDecomp, CDecomp] = mall3df(Data, szArray,  ...
                                        TScale, RScale, CScale, flgInterp)
%%
%%  Initializations
%%
if nargin < 6
    flgInterp = 0;

    if nargin < 3
        error('Temporal scale not provided');
    end
end


[nLeads nSamples] = size(Data);
nRows = szArray(1);
nCols = szArray(2);


%%
%%  Decompose data temporally
%%
TDecomp = -1 * (flipud(mallat1s(flipud(Data'), TScale)))';

if nargout > 1,

    %%
    %%  Decompose data across rows & down columns simultaneously.
    %%
    if flgInterp == 1,
        RDecomp = zeros((nRows-1) * (nCols-1), nSamples);
        CDecomp = zeros((nRows-1) * (nCols-1), nSamples);
    else
        RDecomp = zeros(size(Data));
        CDecomp = zeros(size(Data));
    end

    for iSamp = 1:nSamples

        %%
        %%  Extract the current sample matrix
        %%
        Array = reshape(Data(:,iSamp), nRows, nCols);

        %%
        %%  Compute the transform of columns, working upwards, interpolating
        %%  down columns if requested
        %%
        if flgInterp == 1,
            temp = -1 * mallat1s(interp1([1:nRows], Array,[1:nRows-1]+0.5),...
                                CScale);
            
            temp2 = temp(:, 1:nCols-1);
            CDecomp(:, iSamp) = temp2(:);
        else
            temp = -1 * mallat1s(Array, CScale);
            CDecomp(:, iSamp) = temp(:);
        end

        %%
        %%  Compute the transform along rows, interpolating along rows if
        %%  requested.
        %%
        if flgInterp == 1,
            temp = -1* flipud(mallat1s(flipud(...
                interp1([1:nCols], Array.',[1:nCols-1]+0.5)), ...
                            RScale))';
            temp2 = temp(1:nRows-1, :);
        else
            temp = -1 * flipud(mallat1s(flipud(Array'), RScale))';
            RDecomp(:,iSamp) = temp(:);
        end
   end
end