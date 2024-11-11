%HCG_VALD       Validate the Hot Clutter processing performed by hcg_s0.
%
%    hcg_vald
%
%    strMsrmnt  A string containing the name of the measurement.
%
%	    HCG_VALD reports many of the parameters produced by hcg_S0, it
%    is intended to be employed in validating the accuracy of a Hot Clutter
%    measuremnt set.
%
%    Calls: none
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hcg_vald.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   13 Sep 1993 11:34:52   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%    Header
%%
fprintf('========================================================================\n');
fprintf('CW Transmission file:                  %s\n', fnCWTR);
fprintf('Receiver noise file:                   %s\n\n', fnNoise)

%%
%%    Display the transmitter frequency offset and standard deviation of the
%%    of the estimate.
%%
fprintf('Transmitter frequency offset:          %f Hz\n', DeltaPhase / 2 / pi);
fprintf('Transmitter frequency std:             %f Hz\n\n', PhaseVar / 2 / pi);

%%
%%    Azimuth statistics
%%
fprintf('CW TX mean azimuth:                    %f degrees\n', ...
    mean(CWTRAzimuth));
fprintf('CW TX azimuth range                    +%f,-%f degrees\n\n', ...
    max(CWTRAzimuth - mean(CWTRAzimuth)),min(CWTRAzimuth - mean(CWTRAzimuth)))
%%
%%    Display the measured direct path power levels.
%%
fprintf('CW TX Direct path processed power:     %f dB\n', db(DirPath));
fprintf('CW TX Direct path process std:         %f dB\n', db(DirPathStd));
fprintf('CW TX Direct path dipole peak:         %f dB\n\n', CWTRDipolePeak);

%%
%%    Display measured noise power levels
%%
fprintf('Receiver noise mean power level:       %f dB\n', ...
    db(mean(v2p(NoiseBeamformMF))));
fprintf('Receiver noise path power std:         %f dB\n', ...
    db(std(v2p(NoiseBeamformMF))));
fprintf('Receiver noise mean dipole power:      %f dB\n\n', ...
    db(mean(v2p(NoiseDipoleMF))));


%%
%%    Plot the azimuth range
%%
clf
plot(mean(Azimuth), max(Azimuth - ones(4,1) * mean(Azimuth)), 'x', ...
     mean(Azimuth), min(Azimuth - ones(4,1) * mean(Azimuth)), 'o');
title([strMsrmnt ': Azimuth Error']);
xlabel('Azimuth (degrees)')
ylabel('Range (derees)')
grid
tag
print

%%
%%    Plot the peak dipole level
%%
clf
plot(Azimuth, vDPPeak, 'o')
axis([min(min(Azimuth)) max(max(Azimuth)) CWTRDipolePeak-5 CWTRDipolePeak+5])
title([strMsrmnt ': Peak Dipole Power Level'])
xlabel('Azimuth (degrees)')
ylabel('Amplitude (dB)')
grid
tag
print

%%
%%    Plot the peak dipole index
%%
clf
plot(Azimuth, vDPPeakIdx, 'o')
title([strMsrmnt ': Peak Dipole Index'])
xlabel('Azimuth (degrees)')
ylabel('Index')
grid
tag
print

%%
%%    Plot the processed power associated with the direct path.
%%
clf
plot(Azimuth, db(v2p(vBeamformMFPeak)), '*')
title([strMsrmnt ': Direct Path Power Level'])
xlabel('Azimuth (degrees)')
ylabel('Amplitude (dB)')
grid
tag
print

clf
plot(Azimuth, db(v2p(vBeamformMFPeak)) - max(db(v2p(vBeamformMFPeak))), '*')
title([strMsrmnt ': Direct Path Power Level'])
xlabel('Azimuth (degrees)')
ylabel('Amplitude (dB)')
grid
tag
print