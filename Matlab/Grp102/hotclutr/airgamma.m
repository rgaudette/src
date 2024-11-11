%AIRGAMMA      Convert sigma0 to gamma for the aircraft given sigma0, azimuth,
%              range and a DMA elvation map.
%
%    Gamma = s02gamma(Range, Sigma0, Azimuth, xdist, ydist, dma, TxPos, TxAlt);
%
%    Gamma      The gamma vector.
%
%    Range      [meters].
%
%    Sigma0     [linear].
%
%    Azimuth    [degrees].
%
%    xdist      [kilometers].
%
%    ydist      [kilometers].
%
%    dma        [meters].
%
%    TxPos      [kilometers].
%
%    TxAlt      [meters].
%
%	    Describe function, it's methods and results.
%
%    Calls: az2pol
%
%    Bugs: 
%        Areas off of the DMA map return the use the same height as the last
%    value on the dma map in their row or column.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:28 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: airgamma.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:28  rickg
%  Matlab Source
%
%  
%     Rev 1.0   09 Dec 1993 14:53:16   rjg
%  Initial revision.
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Gamma, SGRatio, SinTheta1, SinTheta2] = ...
    s02gamma(Range, Sigma0, Azimuth, xdist, ydist, dma, TxPos, TxAlt);

%%
%%    Convert all inputs to meters
%%
xdist = xdist * 1000;
ydist = ydist * 1000;
TxPos = TxPos * 1000;

%%
%%    Find the index of the origin of the DMA map.
%%
dx = xdist(2) - xdist(1);
idxXOrigin = find(xdist < dx/2 & xdist > (-dx) / 2);
dy = ydist(2) - ydist(1);
idxYOrigin = find(ydist < dy/2 & ydist > (-dy) / 2);
RSTERAltitude = dma(idxYOrigin, idxXOrigin);

%%
%%    Create position matrix from RSTER
%%
xdist = xdist(:)';
ydist = ydist(:);
Position = ones(size(ydist)) * xdist + j * ydist * ones(size(xdist));

%%
%%    Find dma index & altitude of transmitter
%%
%idxXTxPos = round(real(TxPos) / dx) + idxXOrigin;
%idxYTxPos = round(imag(TxPos) / dy) + idxYOrigin;


%%
%%    Create position matrix relative to the transmitter
TxPosition = Position - TxPos;

%%
%%    Convert the Range, Azimuth data to Cartesion coordinates
%%
[nRange nAzimuth] = size(Range);
Rads = az2pol(Azimuth);
Rads = Rads(:)';
matRads = ones(nRange, 1) * Rads;
[XVal YVal] = pol2cart(matRads, Range);

%%
%%    Compute dma inidicies associated with XVal & YVal
%%
idxX = round(XVal / dx) + idxXOrigin;
idxLow = find(idxX < 1);
idxX(idxLow) = ones(size(idxLow)) * 1;
idxHigh = find(idxX > length(xdist));
idxX(idxHigh) = ones(size(idxHigh)) * length(xdist);

idxY = round(YVal / dy) + idxYOrigin;
idxLow = find(idxY < 1);
idxY(idxLow) = ones(size(idxLow)) * 1;
idxHigh = find(idxY > length(ydist));
idxY(idxHigh) = ones(size(idxHigh)) * length(ydist);

idxDMA = (idxX - 1) * length(ydist) + idxY;

%%
%%    Get ranges from transmitter to cells (R1), get delta heght Tx-cell
%%
R1 = abs(TxPosition(idxDMA));
TxDeltaH = TxAlt - dma(idxDMA); 

%%
%%    Compute sin(theta1)
%%
SinTheta1 = sin(atan(TxDeltaH ./ R1));

%%
%%    Get ranges from cells to RSTER(R1), get delta heght cell-RSTER.
%%
R2 = abs(Position(idxDMA));
RSTERDeltaH = RSTERAltitude - dma(idxDMA);

%%
%%    Compute sin(theta2)
%%
%%    Receiver depression angl clipped at 0.1 degrees
%%
SinTheta2 = sin(clip(atan(RSTERDeltaH ./ R2), 0.1 * pi /180, 10));

%%
%%    Compute sigma-gamma ratio for the cut.
SGRatio = (SinTheta1 + SinTheta2) ./ (2 * SinTheta1 .* SinTheta2);
Gamma = Sigma0 .* SGRatio;
