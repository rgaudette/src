%HCPROC		Process a hot clutter Coherent Processing Interval
%
%    HCPROC is a script that calibrates the 4 cpis present (channels 2 through
%  13, 1 is a assumed to contain dipole data).  Beamforms using the upper
%  13 channels and produces several range doppler maps.  The beamformed range
%  doppler map is range aligned such that the peak direct path response is in
%  range bin 1.  The table below lists the created variables and their
%  meanings.
%
%    dipole		dipole Coherent Processing Interval data.
%    dipoler_rd		dipole Range-Doppler Map.
%    bfcpi		beam-formed cpi.
%    bfrd		beam-formed range-doppler map.
%
%  Required input variables:
%
%    heq		OPTIONAL: equaliztion filter impulse response.
%    apcal		OPTIONAL: amplitude-phase cal data.
%    elev		beam-former elevation.
%    dop_win		Doppler transform window.
%    MFC		Matched filter coefficients (freq domain).
%    PhaseCorr		OPTIONAL: correct phase of even CPIs due to synth.
%			ping-pong in RSTER.  Should be 
%			phase(CPI1) - phase(CPI2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hcproc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.1   27 Oct 1993 11:04:16   rjg
%  Removed subsampling by 13, alignment in range from direct path added.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Beamformer weights
%%
W = svrster(13, elev, 435/450, 3, 60);

%%
%%    Calibrate data if cal coefficients are available, beam-form upper 13
%%    channels and compile big CPIs.
%%
if ~(exist('PhaseCorr') == 1),
    PhaseCorr = 0;
end

if (exist('heq') == 1) & (exist('apcal') == 1),
    disp('Calibrating and beam-forming ....')
    cpi1c = eqapcpi(cpi1, npulses(1), 1, 1, heq, apcal);
    cpi2c = eqapcpi(cpi2 * exp(j*PhaseCorr), npulses(2), 1, 1, heq, apcal);
    cpi3c = eqapcpi(cpi3, npulses(3), 1, 1, heq, apcal);
    cpi4c = eqapcpi(cpi4 * exp(j*PhaseCorr), npulses(4), 1, 1, heq, apcal);
    cal_length = length(cpi1c) / npulses(1);
    dipole = bigcpi(cal_length, 1, cpi1c, cpi2c, cpi3c, cpi4c);
    bfcpi = bigcpi(cal_length, 1, ...
	cpi1c(:,2:14) * conj(W), cpi2c(:,2:14) * conj(W), ...
	cpi3c(:,2:14) * conj(W), cpi4c(:,2:14) * conj(W));
else
    disp('beam-forming data ...')
    dipole = bigcpi(wrecord, 1, ...
	cpi1, cpi2 * exp(j*PhaseCorr) , cpi3, cpi4 * exp(j*PhaseCorr));
    bfcpi = bigcpi(wrecord, 1, ...
	cpi1(:,2:14) * conj(W), ...
	(cpi2(:,2:14) * exp(j*PhaseCorr)) * conj(W) , ...
	cpi3(:,2:14) * conj(W), ...
	(cpi4(:,2:14) * exp(j*PhaseCorr)) * conj(W));
end

%%
%%    Compute Range-Doppler Maps.
%%
disp('Computing Range-Doppler maps ...')
disp('   dipole.........')
dipole_rd = hcrngdop(dipole(1:length(MFC),:), MFC, dop_win);

disp('   beam-formed ...')
bfrd = hcrngdop(bfcpi(1:length(MFC),:), MFC, dop_win);

disp('Aligning direct path range')
[val idxStart ] = max(max(v2p(dipole_rd.')));
bfrd_norm = [bfrd(idxStart:1651, :); bfrd(1:idxStart-1, :)];


