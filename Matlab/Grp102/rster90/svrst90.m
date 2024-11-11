%SVRST90            Generate steeing vectors for RSTER-90
%
%    W = svrst90(nElem, Azimuth, FreqRatio, Window, WinParam)
%
%    result	Output description.
%
%    parm	Input description.
%
%	    Describe function, it's methods and results.
%
%    Calls: windfn.
%
%    Bugs: none known.

%   INPUTS:   ne    :  Number of rows (channels)
%             elev  :  A vector of elevation angles (in degrees)
%                       at which steering vectors are computed.
%             FreqRatio  :  Ratio of transmit frequency to array center
%                       frequency.
%           [Window]:  An optional parameter specifying an amplitude
%                       taper. The taper options are from wintype.m:
%                                 0 -- Uniform (boxcar)
%                                 1 -- Hamming
%                                 2 -- Hanning
%                                 3 -- Chebyshev
%                                 4 -- Kaiser-Bessel
%           [WinParam] :  A parameter for the amplitude taper.
%
%   Note: if Window and param are not specified, uniform SVs are returned.
%
%   OUTPUTS:    sv  :  An (ne x nbeams) matrix whose columns are the
%                       steering vectors pointing to the specified angles,
%                       at the specified frequency and with the
%                       specified amplitude taper.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: svrst90.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:38  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function W = svrster(nElem, Azimuth, FreqRatio, Window, WinParam)

%%
%%    Make sure Azimuth is a row vector, convert to radians.
%%
Azimuth = Azimuth(:).' * pi / 180;

%%
%%    Generate uniform weights for each azimuth requested
%%
Gamma = pi * FreqRatio * sin(Azimuth);

W = exp(j * [0:nElem-1]' * Gamma);

if nargin > 3
    ataper = windfn(nElem, Window, WinParam) ;
    W = diag(ataper) * W ;
end

return
