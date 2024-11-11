%HCGMAP             Call azrmap with standard values from hcg_s0*
%
%    Inputs:
%        Threshold  The SNR threshold [dB].

Sigma0 = hcdet(matSigma0(:,2:38), matNoiseFlr(:,2:38), Threshold);

azrmap(matRange(:,2:38) / 1000, db(Sigma0), mean(Azimuth(:,2:38)), ...
    [-100 0 -100 100], [-70 -10]);
grid
xlabel('KILOMETERS')
ylabel('KILOMETERS')
mkltbig
ch = get(gcf, 'child');
set(gcf, 'CurrentAxes', ch(2));
mkltbig
set(gcf, 'CurrentAxes', ch(1));
