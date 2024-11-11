%ACTVELM1       Activation velocity estimate using Mallat's wavelets
%
%   [vel grad df_dt] = actvelm1(Data, szArray, Scales, idxStart,
%                                           pctThrsh, SaStep)
%
%   vel         Velocity estimate.  This is a complex number with the real
%               part representing horizontal (along rows) velocity and the
%               imaginary part representing vertical (up columns) velocity.
%
%   grad        The spatial gradient estimate at the given scale.
%
%   Data        Lead data.
%
%   szArray     Array size [nRows nCols]
%
%   Scales      Mallat detail scales to use [time x y].
%
%   idxStart    Search start index.
%
%   pctThrsh    Threshold percentage.
%
%   SaStep      Sampling step sizes [dt dx dy].
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
%  $Log: actvelm1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:40  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 16:22:15  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vel, grad, tdb, detT, detG, Tth, Gth] = ...
    actvelm1(Data, szArray, Scales, idxStart, pctThrsh, SaStep)

%%
%%  Default parameters and parameter checking
%%
if nargin < 6,
    SaStep = [1 1 1];
    if nargin < 5,
        pctThrsh = 25;
        if nargin < 4,
            idxStart = 1;
            if nargin < 3,
                Scales = [2 2 2];
                if nargin < 2,
                    if nargin < 1,
                        help actvelm1
                        return;
                    end
                    error('Lead array size must be specified');
                end
            end
        end
    end
end


%%
%%   Compute the derivatives of the signal
%%
disp('Computing backward diff wavelets...');
[tdb rdb cdb] = mall3d(Data, szArray, Scales(1), Scales(2), Scales(3));

%%
%%  Compute the gradient using the combined row & colum derivatives.
%%
disp('Computing gradient...')
grad = wavegrad(rdb, cdb, SaStep(2), SaStep(3));
clear rdb cdb

%%
%%  Select appropriate derivative estimates
%%
disp('Computing velocity...');
tdb = tdb ./ SaStep(1);
vel = actvel(tdb, grad, idxStart, pctThrsh);
