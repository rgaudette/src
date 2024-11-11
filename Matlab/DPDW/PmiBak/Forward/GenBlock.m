%GENBLOCK       Create an absorbing block in a discrete volume.
%
%   x = genblock(CompVol, ctr, dim, value)
%
%   x           The object function.
%
%   CompVol     A structure defining the computational volume.  This
%               structure should have the members: Type, X, Y and Z.  Type
%               should be uniform specifying a uniform sampling volume of
%               voxels. X, Y and Z are vectors specifying the centers of the
%               voxels.
%
%   ctr         The center of the block as [cX cY cZ].
%
%   dim         The length of each side of the block as [lX lY lZ].
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
%  $Log: GenBlock.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:33  rickg
%  Matlab Source
%
%  Revision 2.0  1998/12/23 16:54:32  rjg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = genblock(CompVol, ctr, dim, value)

%%
%%  Create a block centered set of coordinates
%%
if strcmp(CompVol.Type, 'uniform') == 0
    error('This routine only handles uniform voxelations');
end
[X Y Z] = meshgrid(CompVol.X-ctr(1), CompVol.Y-ctr(2), CompVol.Z-ctr(3));

%%
%%  Compute the spherical radius of each coordinate and find all that are ...
%%  within the radius and set them to the delta mu_a
%%
BlkX = abs(X) <= dim(1)/2;
BlkY = abs(Y) <= dim(2)/2;
BlkZ = abs(Z) <= dim(3)/2;
X = (BlkX & BlkY & BlkZ) * value;


