%MFREQPOW	Compute and plot multi-frequency test power levels.
%
%    mfreqpow
%
%    Input variables:
%
%        fnData      The data files containing the multi-frequency data.
%                    Each row of this matrix should contain a valid filename.
%
%        Freq        The frequencies corresponding to the files in fnData
%
%        W           Beamformer coefficients.
%
%    Output variables:
%
%	    MFREQPOW computes the power level received at each frequency
%    from a multi-frequency Hot Clutter test.
%
%    Calls: 
%
%    Bugs:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mfreqpow.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   27 Oct 1993 11:16:42   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Initialization
%%
[nFiles junk] = size(fnData);
ChanPower = zeros(nFiles, 14);
BeamformPow = zeros(nFiles, 1);

%%
%%    Loop over each file
%%
for idxFile = 1:nFiles,
    disp(['Loading: ' fnData(idxFile,:)]);
    load(fnData(idxFile,:));

    %%
    %%    Compute the power in each channel
    %%
    ChanPower(idxFile, :) = mean(v2p([cpi1; cpi2; cpi3; cpi4; cpi5;
                                      cpi6; cpi7; cpi8; cpi9]));

    %%
    %%    Compute the beamformed power in ch 2-13.
    %%
    BeamformPow(idxFile) = mean(v2p([ cpi1(:,2:14) * conj(W);
                             cpi2(:,2:14) * conj(W);
                             cpi3(:,2:14) * conj(W);
                             cpi4(:,2:14) * conj(W);
                             cpi5(:,2:14) * conj(W);
                             cpi6(:,2:14) * conj(W);
                             cpi7(:,2:14) * conj(W);
                             cpi8(:,2:14) * conj(W);
                             cpi9(:,2:14) * conj(W);]));


    clear cpi1 cpi2 cpi3 cpi4 cpi5 cpi6 cpi7 cpi8 cpi9 cpi10
end
