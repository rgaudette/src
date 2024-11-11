%LEADPSNR       Compute the Peak-Signal-to-Noise-Ratio for each lead
%
%   psnr = leadpsnr(Data, idxNoise)
%
%   psnr        PSNR for each lead (in dB).
%
%   Data        The lead array to analyze, each row should contain a
%               different lead.
%
%   idxNoise    The indcies of the noise samples 
%
%
%   LEADPSNR computes the Peak-Signal-to-Noise-Ratio for each lead by
%   computing the variance of the noise in the region(s) describes by 
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: leadpsnr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:45  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function psnr = leadpsnr(Data, idxNoise)

NoisePower = (std(Data(:,idxNoise)') .^ 2)';

PeakPower = ((max(Data') - min(Data')) .^ 2)';

psnr = 10 * log10(PeakPower ./ NoisePower);