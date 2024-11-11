%SPHARMONIC     Spherical harmonic functions.
%
%   Y = spharmonic(l, m, theta, phi)
%
%   Y           The requested spherical harmonic.
%
%   l           The degree of the spherical harmonic.
%
%   m           The order of the spherical harmonic
%
%   theta, phi  The spherical coordinates to evaluate.
%
%
%   SPHARMONIC computes the spherical harmonic function from the associated
%   Legendre functions.
%
%   Calls: none.
%
%   Bugs: DON'T KNOW HOW TO COMPUTE NEGATIVE M VALUES YET!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:04 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: spharmonic.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:04  rickg
%  Matlab Source
%
%  Revision 1.0  1999/02/04 21:23:24  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = spharmonic(l, m, theta, phi)

%%
%%  Need to make theta a row vector in case l=0.  Legendre will return a ...
%%  vectors of ones in the same orientation as the vector theta.
%%
theta = theta(:)';
phi = phi(:);

P = legendre(l, cos(theta));
if m == 0
    Y = sqrt((2*l + 1) / (4 * pi)) * P(1,:)';
else
    Y = sqrt((2*l + 1) / (4 * pi) * (fact((l-m)) / fact(l+m))) * P(m+1,:)' .* ...
        exp (j * m * phi);
end

