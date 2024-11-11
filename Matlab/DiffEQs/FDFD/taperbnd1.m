%POLYBND1      Calculate polynomial spaced sample points for the boundaries.
%
%   [x iBnds] = polybnd1(RoiBnd, RoiStep, nBnd, order, coeff)
%
%   x           The sample points of the domain.
%
%   iBnds       The indexes of the first and last elements in the ROI.
%
%   RoiBnd      The boundaries of the region of interest [roi_min roi_max].
%
%   RoiStep     The step size in the region of interest
%
%   nBnd        The number samples for each tapered boundary.
%
%   order       The order of the polynomial to use.
%
%   coeff       OPTIONAL: a cofficient to scale the step size in the
%               computation of the polynomially spaced boundary sample
%               sample points (default: 1).
%
%   POLYBND1 calculates the sample points for a tapered boundary
%   solution in a 1D domain.  The region of interest (ROI) is uniformly
%   sampled according to RoiBnd and RoiStep.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:01 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: taperbnd1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:01  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, iBnds] = taperbnd1(RoiBnd, RoiStep, order, coeff, nBnd)

%%
%%  Compute the samples for the ROI
%%
roi = [RoiBnd(1):RoiStep:RoiBnd(2)];

%%
%%  Normalize the index map so that the ROI is over [-1 1]
%%
shift = (roi(1) + roi(end)) / 2;
scale = shift - roi(1);
NormStep =  RoiStep / scale;

%%
%%  Compute the normalized tapered boundary samples
%%
NormBndRHS = (1 + NormStep * [1:nBnd]) .^ order;

%%
%%  Rescale back to the requested range
%%
BndRHS = NormBndRHS * scale;
BndLHS = -1 * fliplr(BndRHS);
BndRHS = BndRHS + shift;
BndLHS = BndLHS + shift;

%%
%%  Concatenate the sample sets and return
%%
x = [BndLHS roi BndRHS];