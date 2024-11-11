%GENSPHERE1     Create an absorbing sphere in a discrete volume.
%
%   x = gensphere1(dr, R, ctr, radius, value)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:57 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gensphere1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:57  rickg
%  Matlab Source
%
%  Revision 1.1  1998/06/03 16:03:58  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = gensphere1(dr, R, ctr, radius, value)

%%
%%  Create a disk centered set of coordinates
%%
Xv = [R(1):dr(1):R(2)] - ctr(1);
Yv = [R(3):dr(2):R(4)] - ctr(2);
Zv = [R(5):dr(3):R(6)] - ctr(3);
[X Y Z] = meshgrid(Xv, Yv, Zv);

%%
%%  Compute the spherical radius of each coordinate and find all that are ...
%%  within the radius and set them to the delta mu_a
%%
r = sqrt(X.^2 + Y.^2 + Z.^2);
X =  (r <= radius) * value;

