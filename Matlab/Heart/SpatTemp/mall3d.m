%MALL3D         Process plaque data in 3D using Mallat's algorithm.
%
%   [TDecomp RDecomp CDecomp] = mall3d(Data, szArray, TScale, RScale, CScale)
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
%  $Log: mall3d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:40  rickg
%  Matlab Source
%
%  Revision 1.2  1997/02/11 15:18:54  rjg
%  Added spatial interpolation using Matlab's interp1.
%
%  Revision 1.1  1996/09/11 21:55:55  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [TDecomp, RDecomp, CDecomp] = mall3d(Data, szArray,  ...
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
TDecomp = mallat1s(Data', TScale);
TDecomp = TDecomp';

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
            temp = flipud(mallat1s(flipud(interp1([1:nRows], Array, ...
                        [1:nRows-1]+0.5) ), CScale) );
            
            temp2 = temp(:, 1:nCols-1);
            CDecomp(:, iSamp) = temp2(:);
        else
            temp = flipud(mallat1s(flipud(Array), CScale));
            CDecomp(:, iSamp) = temp(:);
        end

        %%
        %%  Compute the transform along rows, interpolating along rows if
        %%  requested.
        %%
        if flgInterp == 1,
            temp = mallat1s(interp1([1:nCols], Array.',[1:nCols-1]+0.5), ...
                            RScale)';
            temp2 = temp(1:nRows-1, :);
        else
            temp = mallat1s(Array', RScale)';
            RDecomp(:,iSamp) = temp(:);
        end
   end
end