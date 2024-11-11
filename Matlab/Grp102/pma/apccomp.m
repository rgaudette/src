%####################################################################
%
%                 ===>>>  APCCOMP.M  <<<===
%____________________________________________________________________
%
% Programmer:  Jim Ward
%
% Date Code:   10 May 92
% Update Code: 30 June 92
%____________________________________________________________________
%
% Description: a script that computes amplitude and phase constants
%              for each channel. This script is to be used with ANTENNA
%              CALIBRATION (ACAL) data to adjust for the gross amplitude
%              and phase differences that are not present in the loop
%              used for channel equalization.
%
%              This program expects that either CW or pseudonoise
%              (not pulsed) signals are transmitted from a source.
%
%              After equalization, a simple least-squares match of
%              each channel with a reference channel is used to determine
%              the optimum amplitude and phase correction (single complex
%              weight) for each channel. These corrections are collected
%              in a vector 'apcal' and saved in a specified file.
%
%              Amplitude and phase calibration is done for each discrete
%              frequency in the dataset
%____________________________________________________________________
%
% USAGE:  apccomp
%____________________________________________________________________
%
% FUNCTION CALLS:   dbqs
%                   equalize
%                   todb1
%
%####################################################################

%%
%%    Get filename of acal data from user
%%
if exist('cpi1')~=1,
    infile = input('Enter input data filename (no quotes, no .mat):','s');
    eval(['load ',infile]);
end

%%
%%    Get number of CPIs, number of samples and number of channels.
%%
totcpis = length(fxmit);
[nsamptot nch] = size(cpi1);

%%
%% Find the number of frequencies in the data
%%
ifx = find(fxmit == fxmit(1));
if totcpis > 1,
   nfreqs = ifx(2) - 1;
else
   nfreqs = 1;
end

%%
%%    Get frequencies to be cal'ed and preallocate apcal vector.
%%
fcal = fxmit(1:nfreqs);
apcal = zeros(nch,nfreqs);

%%
%%    Get equalizer coefficients if desired
%%
ieq = input('Enter 1 to equalize else enter 0:');
if ieq == 1,
    cft_file = input('Enter cft filename (no quotes, no .mat):','s');
    eval(['load ' cft_file]);
    [nfir ndum] = size(heq); 
end
disp('')

%%
%%    Process the first nfreqs CPIs
%%
nwiny=0; nwinz=0;                % Truncation window default length

for icpi=1:nfreqs,

    disp([' Working on CPI#',int2str(icpi),' of ',int2str(nfreqs),'...']);

    cpitxt = ['cpi',int2str(icpi)];
    [nsamptot nch] = size(eval(cpitxt)); 
    nsamp1 = nsamptot / npulses(icpi);

    eval(['x=',cpitxt,'(1:nsamp1,:);']);

    %%
    %%    If data is ADC convert to BQS
    %%
    if muxtype == 1,
        y = dbqs(x);
        nwiny = 20;
    else
        y = x;
    end
    [nsampy nch] = size(y);
    y = y(1+nwiny:nsampy-nwiny,:);
    [nsampy nch] = size(y);

    %%
    %%    Equalize data if requested.
    %%
    if ieq == 1,
        z = equalize(y,heq);
    else
        z = y;
    end
    [nsampz nch] = size(z);

    %%
    %%    Interactively window the data around the pulse
    %%
    if icpi == 1,
        plpulse(z,1,1,8);
        iwpulse = input('Enter indices [iw1,iw2] to consider:');
        iw1 = iwpulse(1);
        iw2 = iwpulse(2);
        clear iwpulse
    end

    %%
    %%    Compute amplitude and phase corrections
    %%
    zw = z(iw1:iw2,:);
    apcal(:,icpi) = apcmp(zw,0,fxmit(icpi));

end

%%
%%    Save apcal constants on file
%%
apfile=input('Enter file to save A/P constants (no quotes, no .mat):','s');
eval(['save ',apfile,' fcal apcal']);

disp('DONE!')


