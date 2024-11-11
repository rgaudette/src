%=============================================================================
%
%                          ===>>>  SVRSTER.M  <<<===
%_____________________________________________________________________________
%
%   PROGRAMMER : Jim Ward
%
%   DATE   CODE: 19 August 91
%   UPDATE CODE: 14 February 92 -- Properly accounting for antenna
%                                  tilt and compensation delays
%                22 May 92 -- Negative sign for receiver effect
%_____________________________________________________________________________
%
%   DESCRIPTION: A function that returns a steering vector or a
%                matrix of steering vectors for the RSTER array.
%
%                This function assumes compensating delays between each
%                element and its receiver that are equal to the value
%                necessary to exactly compensate for an RSTER antenna tilt
%                of 10 degrees. (so that a signal at 0 deg elevation
%                experiences no dispersion)
%
%                The first element each steering vector corresponds to
%                the TOP row.
%
%                If the taper parameters are not specified, the steering
%                vector is not normalized (u'*u = nel); If the taper type
%                and parameter is specified, the normalization is (u'*u=1);
%_____________________________________________________________________________
%
%   USAGE:  sv=svrster(ne,elev,frat,[itaper,param]) -- tapered SVs
%           sv=svrster(ne,elev,frat)                -- uniform SVs
%_____________________________________________________________________________
%
%   INPUTS:   ne    :  Number of rows (channels)
%             elev  :  A vector of elevation angles (in degrees)
%                       at which steering vectors are computed.
%             frat  :  Ratio of transmit frequency to array center
%                       frequency.
%           [itaper]:  An optional parameter specifying an amplitude
%                       taper. The taper options are from wintype.m:
%                                 0 -- Uniform (boxcar)
%                                 1 -- Hamming
%                                 2 -- Hanning
%                                 3 -- Chebyshev
%                                 4 -- Kaiser-Bessel
%           [param] :  A parameter for the amplitude taper.
%
%   Note: if itaper and param are not specified, uniform SVs are returned.
%
%   OUTPUTS:    sv  :  An (ne x nbeams) matrix whose columns are the
%                       steering vectors pointing to the specified angles,
%                       at the specified frequency and with the
%                       specified amplitude taper.
%_____________________________________________________________________________
%
%   CALLED BY   : MANY FUNCTIONS
%
%   CALLS TO    : windfn  - If optional arguments supplied, will compute a
%                            window function for the steering vector.
%
%=============================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: svrster.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%     Rev 1.0   22 Feb 1993 16:36:40   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u=svrster(ne,elev,frat,itaper,param)

dtr = pi / 180.0 ;
thtilt = 11.5 ;        % Antenna tilt angle off vertical axis
thtcomp= 10 ;        % Amount of effective tilt compensation
ine = 1 : ne ;
nbeams = max(size(elev)) ;

gamma = pi * frat * ( sin((elev-thtilt)*dtr) + sin(thtcomp*dtr) ) ;

u=zeros(ne,nbeams);

for ib = 1 : nbeams,
    u(:,ib) = exp( j* gamma(ib) * (ine-ones(size(ine))) ).' ;
end

if nargin > 3
 ataper=windfn(ne,itaper,param) ;
 u=diag(ataper)*u ;
end

return
