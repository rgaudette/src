%CON_RSDS       Construct a RSTER Signal data structure.
%
%    strcRSDS = con_rsds(ant_tilt, azxmit, calflag, cpiidx, cpitime, ...
%                   cpitype, elxmit, fxmit, muxtype, npulses, pri, scanidx, ...
%                   tpulse, trecord, wrecord, tx_wfm)
%
%    tx_wfm     OPTIONAL: Transmitter waveform code see table below, (default:
%               PCW if pulse width is less than 50 uSecs otherwise LFM).
%
%
%        CON_RSDS constructs a RSTER signal data structure.
%
%    Calls: RSDS_def.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: con_rsds.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function strcRSDS = con_rsds(ant_tilt, azxmit, calflag, cpiidx, cpitime, ...
                           cpitype, elxmit, fxmit, muxtype, npulses, pri, ...
                           scanidx, tpulse, trecord, wrecord, tx_wfm)

%%
%%    Chack to make sure that the number of CPIs is consistent in all vectors.
%%
chk = zeros(9, 1);
[chk(1) junk] = size(azxmit);
[chk(2) junk] = size(cpiidx);
[chk(3) junk] = size(cpitime);
[chk(4) junk] = size(elxmit);
[chk(5) junk] = size(fxmit);
[chk(6) junk] = size(npulses);
[chk(7) junk] = size(pri);
[chk(8) junk] = size(scanidx);
[chk(9) junk] = size(tpulse);
Bad = chk(1) ~= chk;
if any(Bad), 
    error('Incrrect number elements in vector type');
end

%%
%%    Create required structures
%%
nCPIS = chk(1);
strcRSDS = zeros(nCPIS, 21);
OnesVec = ones(nCPIS,1);

%%
%%    Version ID
%%
strcRSDS(:,1) = OnesVec * 1.0;

%%
%%    Insert data vars
%%
strcRSDS(:,2) = OnesVec * ant_tilt;
strcRSDS(:,3) = azxmit;
strcRSDS(:,4) = OnesVec * calflag;
strcRSDS(:,5) = cpiidx;
strcRSDS(:,6:11) = cpitime;
strcRSDS(:,12) = cpitype;
strcRSDS(:,13) = elxmit;
strcRSDS(:,14) = fxmit;
strcRSDS(:,15) = OnesVec * muxtype;
strcRSDS(:,16) = npulses;
strcRSDS(:,17) = pri;
strcRSDS(:,18) = scanidx;
strcRSDS(:,19) = tpulse;
strcRSDS(:,20) = OnesVec * trecord;
strcRSDS(:,22) = OnesVec * wrecord;

%%
%%    If tx_wfm is not provided
%%
if nargin < 16
    if tpulse(1) < 50e-6, 
        strcRSDS(:,21) = OnesVec * 1;
    else
        strcRSDS(:,21) = OnesVec * 2;
    end
end
