%PLANE_2D       Generate a 2D plane wave
%
%   f = plane_2d(szArray, nTemp, Offset, Kx, Ky, w, fctWave, arg1, arg2)
%
%   szArray     This should be a two element vector in the form [nRows nCols].
%               The coordinate of each element are its indices.
%
%   nTemp       The number of temporal samples to generate.
%
%   Offset      The spatial and temporal offsets in the form [Xo Yo To].
%
%   kx, ky      The spatial wavenumbers for the x and y dimensions respectively.
%
%   w           The temporal frequency parameter.
%
%   fctWave     The function that generates the desired waveshape
%
%   arg1, arg2  [OPTIONAL] As needed additional parameters to the wave
%               function, see help for the particular function.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:21 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: plane_2d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:21  rickg
%  Matlab Source
%
%  Revision 1.5  1997/08/06 20:58:03  rjg
%  Changed calling for to kx, ky, w.
%
%  Revision 1.4  1997/07/31 19:42:33  rjg
%  No need to pre-allocate the function array.
%
%  Revision 1.3  1997/04/08 00:43:48  rjg
%  Converted meshdom call to meshgrid call for MATLAB 5
%
%  Revision 1.2  1997/03/27 21:15:01  rjg
%  Velocity parameter was multplied instead of divided.
%
%  Revision 1.1  1997/01/22 19:06:25  rjg
%  Initial revision
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = plane_2d(szArray, nTemp, Offset, kx, ky, w, fctwave, arg1, arg2)

%%
%%  Compute and report slowness vector and velocity vector
%%
K = sqrt(kx^2 + ky^2);
magV = w / K;
angV = atan2(ky, kx);
V = magV * exp(j*angV);
disp(['Velocity vector: ' num2str(real(V)) '  ' num2str(imag(V))]);
disp(['Magnitude: ' num2str(magV) '  Angle: ' num2str(angV*180/pi) ' degrees']);

%%
%%  Create array of x & y coordinates for each element location.
%%
[x y] = meshgrid([0:szArray(2)-1], [0:szArray(1)-1]);
y = flipud(y);

%%
%%  Offset the coordinates
%%
x = x - Offset(1);
x = repmat(x(:), 1, nTemp);
y = y - Offset(2);
y = repmat(y(:), 1, nTemp);
t = [0:nTemp-1] - Offset(3);
t = repmat(t, szArray(1) * szArray(2), 1);

%%
%%  Compute the argument to the function
%%
farg = kx * x + ky * y - w * t;

if nargin == 7,
    f = feval(fctwave, farg);
elseif nargin == 8;
    f = feval(fctwave, farg, arg1);
else
    f = feval(fctwave, farg, arg1, arg2);
end
