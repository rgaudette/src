%ELLIP_2D       Generate a 2D elliptical wave
%
%   f = ellip_2d(szArray, nTemp, Initial, Vel, Rotation, fctWave, arg1, arg2)
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
%   ELLIP_2D generates an elliptical wavefonts in 2 spatial dimensions and 
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
%  $Log: ellip_2d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:21  rickg
%  Matlab Source
%
%  Revision 1.4  1997/07/07 20:38:11  rjg
%  Changes meshdom to meshgrid for MATLAB 5.
%
%  Revision 1.3  1997/03/27 20:55:44  rjg
%  Fixed help comments
%
%  Revision 1.2  1997/01/22 18:14:52  rjg
%  Updated help section.
%
%  Revision 1.1  1997/01/21 20:17:04  rjg
%  Initial revision
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = ellip_2d(szArray, nTemp, Initial, Vel, Rotation, ...
            fctWave, arg1, arg2)

%%
%%  Preallocate function array
%%
f = zeros(szArray(1)*szArray(2), nTemp);

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
%%  Rotate the coordinates of the array
%%
radRot = Rotation * pi / 180;
x_prime = x * cos(radRot) + y * sin(radRot);
y_prime = x * (-1)*sin(radRot) + y * cos(radRot);

%%
%%  Compute the zero phase time of each array element and the argument
%%  matrix to the function.  This matrix has the same format as the data.
%%  Time is a function of the column index, position is a function of the
%%  row index.
%%
t0 = sqrt((x_prime ./ Vel(1)).^2 + (y_prime ./ Vel(2)).^2);
fct_arg = ones(szArray(1)*szArray(2), 1) * ([1:nTemp] - Initial(3)) - ...
            t0(:) * ones(1, nTemp);

if nargin < 7
    f = feval(fctWave, fct_arg);
elseif nargin == 7,
    f = feval(fctWave, fct_arg, arg1);
else
    f = feval(fctWave, fct_arg, arg1, arg2);
end
