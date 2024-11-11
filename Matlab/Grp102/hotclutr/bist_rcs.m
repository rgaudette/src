%BIST_RCS	Compute the required bistatic RCS to exceed the noise floor.
%
%    This script computes the minimum sigma naught requirements for
%  the clutter response to exceed the noise floor of RSTER.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bist_rcs.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.2   10 Aug 1993 09:05:08   rjg
%  Uses lfrank2 model for transmitter antenna.
%  
%     Rev 1.1   03 Aug 1993 23:32:12   rjg
%  Updated code to include more sites.
%  
%     Rev 1.0   26 Mar 1993 11:00:26   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function bist_rcs(parm)

%%
%%    System parameters
%%
Beam 	= 6 * pi / 180;		% RSTER beam width
Gj 	= 10 ^ (11.6 / 10);	% Boresight jammer antenna gain
Gr 	= 10 ^ (29 / 10);	% RSTER antenna gain
IF_BW 	= 300e3;		% RSTER IF Bw
Pw 	= 13e-6;		% Jammer pulse width
%nPulses = 127;			% Number of integration periods for PN
nPulses = 1;			% Number of integration periods for PCW
lambda 	= 3e8 / 435e6;		% Wavelength
N 	= nPulses * Pw * IF_BW;	% Range integration gain
M 	= 64;			% Doppler integration gain
Pj 	= 75;			% Jammer power
Ptn 	= 10 ^ (-144 / 10);	% RSTER thermal noise power 
SNR 	= 10 ^ (5 / 10);	% Minimum det. SNR

%%
%%    Transmitter position wrt RSTER
%%

%%
%%	Lookout Mountain
%%
%TxPos = (-136.11-j*44.16) * 1000;

%%
%%	M Mountain
%%
TxPos = (-57.33+j*34.04) * 1000;

%%
%%	Sierra Blanca
%%
%TxPos = (52.26-j*41.86) * 1000;

%%
%%	Salinas Peak
%%
%TxPos = (-15.60-j*49.68) * 1000;

%%
%%    Sampling grid relative to RSTER,
%%
%%	matches dma1 map.
%%x = [-100.23:.39:21.45] * 1000;
%%y = [44.62:-.46:-44.16] * 1000;
x = [-200:1:100] * 1000;
y = [125:-1:-125] * 1000;
Ymat = y' * ones(1,length(x));
Xmat = ones(length(y),1) * x;
Position = Xmat + j*Ymat;

%%
%%    Polar coordinates from Tx to patch
%%
rect_coord = (Position - TxPos);
R1sq = real(rect_coord .* conj(rect_coord));
R1 = sqrt(R1sq);
TxTheta = angle(rect_coord) - angle(TxPos) + pi;

%%
%%   Compute gain of transmit antenna in direction of patch.
%%
GjTheta = lfrank(TxTheta);

%%
%%    Fold antenna
%GjTheta = Gj * cos(TxTheta);
%[row col] = size(GjTheta);
%GjTheta = GjTheta(:);
%MinIndex = find(GjTheta < 0.04);
%GjTheta(MinIndex) = 0.04 * ones(size(MinIndex));
%GjTheta = reshape(GjTheta, row, col);

%%
%%    Polar coordinated from Patch to Rx
%%
R2sq = real(Position .* conj(Position));
R2 = sqrt(R2sq);
range_prod = R1sq .* R2sq;

%%
%%    Spacially constant part of equation.
%%
constant = 64 * pi .^ 3 * Ptn * SNR / ...
    ( Pj * Gr * lambda ^ 2 * N * M);

%%
%%    Required rcs to exceed noise floor.
%%
rcs = constant * range_prod ./ GjTheta;

%%
%%    Bistatic resolution cell area wrt to x anad y.
%%
Ab = bist_res(1/Pw, Beam, TxPos, Position);

%%
%%    Sigma naught required to exceed noise floor as a function of x and y.
%%
Sigma = rcs ./ Ab;
SigmadB = 10 * log10(abs(Sigma));
