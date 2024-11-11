%ELLIP_2DM4     Generate a 2D elliptical wave
%
%   f = ellip_2dm4(szArray, nTemp, Initial, w, Vel, Rotation, ...
%                fctWave, arg1, arg2)
%
%   szArray     This should be a two element vector in the form [nRows nCols].
%               The coordinate of each element are its indices.
%
%   nTemp       The number of temporal samples to generate.
%
%   Initial     The initial starting point of the wavefront as a three
%               element vector.  This first two are the x and y locations,
%               the third is the starting time of the wave.
%
%   Vel         The major and minor velocities as a vector [vMajor vMinor].
%
%   Rotation    The rotation of the ellipse with respect to the X axis.
%               0 means the major axis and the x axis are coincident.
%               (degrees)
%
%   fctWave     The function that generates the desired waveshape.
%
%   arg1, arg2  [OPTIONAL] additional arguments to waveshape function.
%
%   ELLIP_2DM4 generates an elliptical wavefonts in 2 spatial dimensions and 
%   time.  The temporal shape of the wavefront can be any 1D function and
%   is specified by the string fctWave.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:21 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: ellip_2dm4.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:21  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = ellip_2dm2(szArray, nTemp, Initial, w, Vel, Rotation, ...
            fctWave, arg1, arg2)

%%
%%  Create array of x & y coordinates for each element location.
%%
[x y] = meshgrid([0:szArray(2)-1], [0:szArray(1)-1]);
y = flipud(y);

%%
%%  Offset the coordinates
%%
x = x - Initial(1);
y = y - Initial(2);


%%
%%  Rotate the coordinates of the array so that the new X axis is parallel to
%%  the major axis of the ellipse
%%
radRot = Rotation * pi / 180;
x_prime = x * cos(radRot) + y * sin(radRot);
y_prime = x * (-1)*sin(radRot) + y * cos(radRot);

%%
%%  Repeat spatial and temporal arguments for the necessary domains
%%
x_prime = repmat(x_prime(:), 1, nTemp);
y_prime = repmat(y_prime(:), 1, nTemp);
t = [0:nTemp-1] - Initial(3);
t = repmat(t, szArray(1)*szArray(2), 1);

%%
%%  Compute the argument to the function
%%
a = Vel(1) / w;
b = Vel(2) / w;
fct_arg = sqrt((x_prime ./ a).^2 + (y_prime ./ b).^2) - w * t;

if nargin < 8
    f = feval(fctWave, fct_arg);
elseif nargin == 8,
    f = feval(fctWave, fct_arg, arg1);
else
    f = feval(fctWave, fct_arg, arg1, arg2);
end
