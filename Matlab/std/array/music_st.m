st = clock;
theta = [-5:.1:15];
%%
%%    Load in cal & eq coef files
%%
load m11d24ap
load m11d24cft
[nHEQ cols] = size(heq);

%%
%% Loop over each file
%%
for idxFile = 1:23
    strFileNum = sprintf('%02.0f', idxFile);
    disp(['File number : ' strFileNum]);
    eval(['load jamr00' strFileNum 'v1']);

    nEQRangeGates = wrecord - nHEQ + 1;

    %%
    %%    Loop over each CPI
    %%
    NCPI = length(npulses);

    for idxCPI = 1:NCPI,
	disp(['    CPI index : ' int2str(idxCPI)]);
	%%
	%%    Extract the Pre-Transmisson Sampling Interval
	%%    check to make sure that the cpitype has a PTSI
	%%
	if cpitype(idxCPI) ~= 5,
	    error(['Don''t know how to handle cpi type ' ...
		num2str(cpitype(idxCPI))]);
	end
	eval(['ptsi = cpi' int2str(idxCPI) '(1:300,:);']);

	%%
	%%    Equalize psti, and decimate by 4.
	%%
	ptsi = eqapcpi(ptsi, 1, 1, 1, heq, apcal);
	ptsi = ptsi([1:4:270], :);
	
	%%
	%%   Perform music on PTSI
	%%
	strCPINum = sprintf('%02.0f', idxCPI);
	eval(['mus_spec_' strFileNum '_' strCPINum ...
	    '(:,1)=music(ptsi.'', 2, theta);']);

	%%
	%%   Equalize the remaining pulses.
	%%

	idxNonPTSI = (1:wrecord * npulses(idxCPI)) + 300;
	eval(['EQPulses = eqapcpi(cpi' int2str(idxCPI) ...
	    '(idxNonPTSI,:),npulses(idxCPI),1,1,heq,apcal);']);


	%%
	%%    Loop over each pulse computing a new music spectrum.
	%%
	for idxPulse = 1:npulses(idxCPI),
	    PulseStart = (idxPulse - 1) * nEQRangeGates + 1;
	    DecimPulse = EQPulses(PulseStart:4:PulseStart+268,:);
	    eval(['mus_spec_' strFileNum '_' strCPINum ...
	    '(:,idxPulse+1)=music(DecimPulse.'', 2, theta);']);
	end
   end

end

clear cpi1 cpi2 cpi3 cpi4 cpi5 cpi6 cpi7 cpi8 cpi9 cpi10 cpi11 cpi12
clear cpi13 cpi14 cpi15 cpi16
TotalTime = etime(clock,st);
disp(['processing time : ' num2str(TotalTime)]);
save JamrMusic

