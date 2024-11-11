%BIST_SLL	Compute the sidelobe limited bistat RCS.
%
%    This script computes the minimum sigma naught requirements for
%  the clutter response to exceed the direct path sidelobe signal of the
%  transmitter.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bist_sll.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.2   27 Oct 1993 11:33:04   rjg
%  Fixed help section.
%  
%     Rev 1.1   03 Aug 1993 23:35:30   rjg
%  Added more transmitter sites, accounted for TX pattern better.
%  
%     Rev 1.0   26 Mar 1993 11:01:52   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function bist_sll(parm)

%%
%%    System parameters
%%
Beam = 6 * pi / 180;		% RSTER beam width
Gj = 10 ^ (11.6 / 10);		% Boresight jammer antenna gain
MSRmin = 10 ^ (5 / 10);	% Minimum mainlobe-to-sidelobe ratio
Pw = 13e-6;			% Jammer pulse width
ASLL = 10 ^ (-60 / 10);		% Azimuth sidelobe level
RSLL = 10 ^ (-40 / 10);		% Range sidelobe level

%%
%%    Transmitter position wrt RSTER
%%

%%
%%	Lookout Mountain
%%
TxPos = (-136.11-j*44.16) * 1000;

%%
%%	M Mountain
%%
%TxPos = (-57.33+j*34.04) * 1000;

%%
%%	Sierra Blanca
%%
%TxPos = (52.26-j*41.86) * 1000;

%%
%%	Salinas Peak
%%
%TxPos = (-15.60-j*49.68) * 1000;

%%
%%    Sampling grid relative to RSTER
%%
%% matches dma1 map.
%x = [-100.23:.39:21.45] * 1000;
%y = [44.62:-.46:-44.16] * 1000;
x = [-200:100] * 1000;
y = [125:-1:-125] * 1000;
Ymat = y' * ones(1,length(x));
Xmat = ones(length(y),1) * x;
Position = Xmat + j*Ymat;

%%
%%    Polar coordinates from Tx to patch
%%
rect_coord = (Position - TxPos);
R1sq = real(rect_coord .* conj(rect_coord)) ;
TxTheta = angle(rect_coord) - angle(TxPos) + pi;

%%
%%   Compute gain of transmit antenna in direction of patch.
%%
GjTheta = Gj * cos(TxTheta);
[row col] = size(GjTheta);
GjTheta = GjTheta(:);
MinIndex = find(GjTheta < 0.04);
GjTheta(MinIndex) = 0.04 * ones(size(MinIndex));
GjTheta = reshape(GjTheta, row, col);

%%
%%    Range from Patch to Rx
%%
R2sq = real(Position .* conj(Position));

%%
%%    Evaluate Sigma Naught minimum function wrt to sidelobe level.
%%
range_prod = R1sq .* R2sq;

%%
%%    Spacially constant part of equation.
%%
constant = Gj * 4 * pi * ASLL * RSLL * MSRmin / ...
    abs(TxPos) .^ 2

%%
%%    Required rcs to exceed direct path signal.
%%
rcs = constant * range_prod ./ GjTheta;

%%
%%    Bistatic resolution cell area wrt to x anad y.
%%
Ab = bist_res(1/Pw, Beam, TxPos, Position);

%%
%%    Sigma naught required to exceed direct path signal as a function of x 
%%  and y.
%%
Sigma = rcs ./ Ab;
SigmadB = 10 * log10(abs(Sigma));
