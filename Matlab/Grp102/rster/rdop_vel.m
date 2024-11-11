%RDOP_VEL           Compute a target velocity given given a set of RSTER
%                   parameters and the targets position in doppler space.
%
%    Speed = rdop_vel(DopplerBin, FreqCntr, nDoppler, PRI, strDirect, strUnits)
%
%    Speed          The computed target velocity positive is inbound
%                   [units specified by strUnits].
%
%    DopplerBin     The target Doppler bin.  Bins are indexed from 0 to 
%                   nDoppler-1, it may also be a floating point number.
%
%    FreqCntr       The radar center frequency [Hz].
%
%    nDoppler       The number of bins in the Doppler space.
%
%    PRI            The pulse repetion interval [Seconds].
%
%    strDirect      OPTIONAL:  Specifes wether the target is 'inbound',
%                   'outbound', or 'unaliased'.  If this parameter is 'inbound'
%                   or 'outbound' an aliased target will be correctly computed
%                   (for the an additional 1/2 of the doppler space).
%                   'Unaliased' specifies that the target can be either inbound
%                   or outbound but only from -1/2 to 1/2 of the doppler space.
%                   (default: 'unaliased').
%
%    strUnits       OPTIONAL: Specifies the units of speed to return.  This
%                   can be either 'm/s' for meters-per-second, 'kph' for 
%                   kilometers-per-hour, 'mph' for miles-per-hour or 'knots'
%                   for knots.
%
%	    RDOP_VEL computes the speed of a target
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rdop_vel.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:38  rickg
%  Matlab Source
%
%  
%     Rev 1.0   10 Mar 1994 10:57:10   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Speed = rdop_vel(DopplerBin, FreqCntr, nDoppler, PRI, ...
                          strDirect, strUnits)

%%
%%    Default parameters
%%
if nargin < 6,
    strUnits = 'm/s';
    if nargin < 5,
        strDirect = 'unaliased';
    end
end

%%
%%    Constants
%%
C = 299792458;

%%
%%    Compute true Doppler frequency of the revceived signal.  This requires
%%    taking into account inverted Doppler frequency sense of RSTER and
%%    wether the target is inbound or outbound.
if strcmp(lower(strDirect), 'unaliased'),
    NegIndex = find(DopplerBin > (nDoppler / 2));
    DopplerBin(NegIndex) = DopplerBin(NegIndex) - nDoppler;
    DopplerBin = -1 * DopplerBin;

elseif strcmp(lower(strDirect), 'inbound'),
    disp('Inbound')
    idxZeros = find(DopplerBin == 0.0);
    if length(idxZeros),
        DopplerBin(idxZeros) = DopplerBin(idxZeros) + nDoppler;
    end
    DopplerBin = nDoppler - DopplerBin;

elseif strcmp(lower(strDirect), 'outbound'),
    DopplerBin = -1  * DopplerBin;

else
    error('Incorrect direction specifier in rdop_vel.');
end

frqDoppler =  DopplerBin / nDoppler / PRI;

%%
%%    True Doppler frequency to speed
%%
Speed = C / FreqCntr * frqDoppler / 2;

%%
%%    Convert to specified units if neccessary
%%
if strcmp(lower(strUnits), 'kph'),
    Speed = Speed / 1000 * 3600;

elseif strcmp(lower(strUnits), 'mph'),
    Speed = Speed * 2.23693629205;

elseif strcmp(lower(strUnits), 'knots'),
    Speed = Speed * 1.94384449244;

elseif strcmp(lower(strUnits), 'm/s') == 0,
    error('Unknown speed units');
end
