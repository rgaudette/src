%GENSPHERE1     Create an absorbing sphere in a discrete volume.
%
%   x = gensphere1(CompVol, ctr, radius, value)
%
%   x           The object function.
%
%   CompVol     A structure defining the computational volume.  This
%               structure should have the members: Type, X, Y and Z.  Type
%               should be uniform specifying a uniform sampling volume of
%               voxels. X, Y and Z are vectors specifying the centers of the
%               voxels.
%
%   ctr         The center of the sphere.
%
%   radius      The radius of the sphere.
%
%   value       The value within the boundaries of the sphere.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: GenSphere1.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:33  rickg
%  Matlab Source
%
%  Revision 2.0  1998/08/05 15:50:55  rjg
%  Start of version 2
%  Handles structure for computational volume.
%
%  Revision 1.1  1998/06/03 16:03:58  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = gensphere1(CompVol, ctr, radius, value)

%%
%%  Create a disk centered set of coordinates
%%
if strcmp(CompVol.Type, 'uniform') == 0
    error('This routine only handles uniform voxelations');
end
[X Y Z] = meshgrid(CompVol.X-ctr(1), CompVol.Y-ctr(2), CompVol.Z-ctr(3));

%%
%%  Compute the spherical radius of each coordinate and find all that are ...
%%  within the radius and set them to the delta mu_a
%%
r = sqrt(X.^2 + Y.^2 + Z.^2);
X =  (r <= radius) * value;

