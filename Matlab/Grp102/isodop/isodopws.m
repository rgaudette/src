%ISODOPWS		Generate iso-doppler contour lines for WSMR map.
%
%    DopplerBin = isodopws(Heading, Velocity, PRF, NPulses, SampIntrvl, ...
%			  RangeStep, flgPosDoppler)
%
%    isodopws(RangeStep)
%
%    DopplerBin		Doppler bin matrix
%
%    Heading		The appearent heading of the radar (degrees).
%
%    Velocity		The appearent velocity of the radar (m/s).
%
%    PRF		Pulse repetition frequency.
%
%    NPulses		The number of pulses for doppler processing.
%
%    SampIntrval	The X & Y sampling interval for the contour map
%			(kilometers).
%
%    RangeStep		OPTIONAL: The distance between iso-range contours, use
%			0 for none (kilometers).  Default: 0.
%
%    flgPosDoppler	OPTIONAL: set this flag to use only positive dopplers
%			(causes a wraparound wall at the zero doppler contour).
%
%	    ISODOPWS computes the iso-doppler contours for the White Sands
%    Missle Range scenario.  It assumes a 4/3 earth model, and a platform
%    elevation of 4000 feet above the surrounding terrain.  The second calling
%    convention produces only iso-range contours.
%
%    Calls: none

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:36 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: isodopws.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:36  rickg
%  Matlab Source
%
%  
%     Rev 1.0   26 Feb 1993 15:17:12   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DopplerBin = isodopws(Heading, Velocity, PRF, NPulses, SampIntrvl, ...
    RangeStep, flgPosDoppler)

if nargin < 7,
    flgPosDoppler = 0;
    if nargin < 6,
	RangeStep = 0;
	if nargin < 5,
	    SampIntrvl = 0.5;
	end
    end
end

if nargin == 1,
    RangeStep = Heading;
end

%%
%%    Constants
%%
earth_radius = 4/3 * 6370;	% 4/3 earth model, kilometers.
platform_el = 1.219;		% 1.219 Km. 4000 ft above surrounding terrain
C = 3e8;
Freq = 435e6;
lambda = C /Freq;

%%
%%    X Y grid (kilometers)
%%
x = [-152.75:SampIntrvl:36.01];
y = [40.24:-SampIntrvl:-71.29];
Ymat = y' * ones(1,length(x));
Xmat = ones(length(y),1) * x;
Position = Xmat + j*Ymat;
Range = abs(Position);

%%
%%    Generate iso-doppler contours if requested
%%
if nargin > 1,
    %%
    %%  Aspect angle is with respect east, shift to appearent heading.
    %%
    Offset = (Heading + 90) * pi / 180;
    Aspect = angle(Position);
    Aspect = Aspect + Offset;

    %%
    %%    Compute relative elevation.
    %%
    h1 = sqrt(earth_radius ^ 2 - Range .^ 2);	% depression due to range
    h2 = platform_el + earth_radius - h1;	% appearent elevation
    elev_angle = atan(h2 ./ Range);

    %%
    %%    Compute radial velocity of each point.
    %%
    RadialVel = -Velocity * cos(Aspect) .* cos(elev_angle);

    %%
    %%    Doppler frequency computation
    %%
    DopplerRes = PRF / NPulses;
    DopplerFreq = 2 / lambda * RadialVel;
    DopplerBin = round(DopplerFreq / DopplerRes);

    %%
    %%	Select doppler bin range
    %%
    if flgPosDoppler == 1,
        DopplerBin = rem(DopplerBin, NPulses);
        NegIndex = find(DopplerBin < 0);
        DopplerBin(NegIndex) = DopplerBin(NegIndex) + NPulses;
        ContourMin = 0;
	ContourMax = ContourMin + Npulses - 1;
    elseif flgPosDoppler == 0,
        DopplerBin = rem(DopplerBin, NPulses);
        Aliased = find(DopplerBin > fix(NPulses/2-1));
        DopplerBin(Aliased) = DopplerBin(Aliased) - NPulses;
        ContourMin = fix(-NPulses / 2); 
	ContourMax = ContourMin + Npulses - 1;
    else
	ContourMin = min(min(DopplerBin));
	ContourMax = max(max(DopplerBin));
    end
end

%%
%%    Graphics control
%%
clg

%%
%%    Axes for photograph
%%
axes('position', [1.36/11 1.94/8.5 8.02/11 4.74/8.5], ...
    'XTick', [], 'YTick', [], 'Box', 'on');

orient landscape

%%
%%    Plot iso-dopplers if requested
%%
if nargin > 1,
    c_struct = contour(x, y, DopplerBin, [ContourMin:ContourMax]);
%    clabel(c_struct, [ContourMin:ContourMax]);
%    clabel(c_struct, 'manual');
    hold on
end



%%
%%    Plot iso-range contours if asked.
%%
if RangeStep > 0,
    RangeRings = [0:RangeStep:max(max(Range))];
    contour(x, y, Range, RangeRings);
    hold on
end

%%
%%    Mark origin (North Oscura Peak).
%%
plot(0,0, '+');

hold off
