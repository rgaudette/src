%FILTPLT        Plot the pass/stop band characteristics of a bandpass filter.
%
%   filtplt(b, a, f, m, Fs)
%
%   a,b     The LCCDEQ coefficients.
%
%   f       The passband and stopband frequencies, in the same format as REMEZ.
%
%   m       The magnitudes of the bands in f.
%
%   Fs      [optional] The sampling rate.

function filtplt(b, a, f, m, Fs)

if nargin < 5,
    Fs = 1;
end

nband = length(f)/2;

%%
%%  Generate the frequency response of the filter
%%
h = freqz(b, a, 1024);

%%
%%  Generate a frequency vector. Maps 0 to pi to 0 to 1 (same as most MATLAB
%%  routines.
%%
freq_vec = linspace(0, 1, length(h));

%%
%%  Loop over each band plotting the linear and logarithmic characteristics.
%%
for iband = 1:nband,
    
    %%
    %%  Create a row of plots for each stop and passband.
    %%
    subplot(nband, 2, iband*2-1);

    %%
    %%  Find elements of h that correspond to this band
    %%
    f_band = freq_vec(find( (freq_vec >= f(2*iband-1)) & (freq_vec <= f(2*iband)) ));
    h_band = h(find( (freq_vec >= f(2*iband-1)) & (freq_vec <= f(2*iband)) ));

    plot(f_band/2*Fs, abs(h_band), 'r');
    xlabel('Frequecy')
    ylabel('Amplitude')
    title(['Linear Magnitude Band # ' int2str(iband)]);
    
    %%
    %%  Is this a pass or a stop band
    %%
    peak = max(abs(h_band));
    low = min(abs(h_band));
    if m(2*iband) > 0,
        peak
        low
        axis([f(2*iband-1)/2*Fs f(2*iband)/2*Fs low-.05 peak+.05]);
    else
        peak
        axis([f(2*iband-1)/2*Fs f(2*iband)/2*Fs  0 peak+.02]);
    end
    grid
    
    subplot(nband, 2, iband*2);
    plot(f_band/2*Fs, db(v2p(h_band)), 'r');
    xlabel('Frequecy')
    ylabel('Amplitude')
    title(['Logarithmic Magnitude Band # ' int2str(iband)]);
    
    if m(2*iband) > 0,
        axis([f(2*iband-1)/2*Fs f(2*iband)/2*Fs db(v2p(low))-1 db(v2p(peak))+1]);
    else
        axis([f(2*iband-1)/2*Fs f(2*iband)/2*Fs db(v2p(peak))-20 db(v2p(peak))+5]);
    end
    grid

end

