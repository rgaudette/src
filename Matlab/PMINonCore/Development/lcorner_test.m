% A script to walk through the L-corners of a bunch of SNRs

SNR = [5:5:60];
nSNR = length(SNR);
for iSNR = 1:nSNR
    SNR(iSNR)
    strSNR = sprintf('%02.0f', SNR(iSNR));
    eval(['resd = resid_tsvd3D' strSNR '(1:275);']);
    eval(['xnorm = norm_tsvd3D' strSNR '(1:275);']);
    eval(['r = r_tsvd3D' strSNR ';']);
    regc = lcorner_simple2deriv(resd, xnorm)
    
    figure(1)
    clf
    plot(log(resd), log(xnorm));
    hold on
    plot(log(resd(regc)), log(xnorm(regc)), 'xr', 'linewidth', 2);
    title(['SNR = ' int2str(SNR(iSNR)) 'dB']);
    pause
end

    
