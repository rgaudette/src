%TV3D           Calculate the total variation for a 3D dataset (cube)
%
%   [tv gradop] = tv2d(cube, dims, flgEdge)
%
%   tv          The total variation for the cube. 
%
%   gradop      The gradient operator.
%
%   cube        The data cube to evaluate 
%
%   dims        OPTIONAL: The dimensions of the cube if it is in vector
%               format [nY nX nZ] = [nR nC nP].  If dims is not supplied the
%               cube is expected have three dimensions and not be in vector
%               format.
%
%   flgSparse   OPTIONAL: Use a sparse matrix representation of the gradient
%               operator (default: 1).
%
%   flgEdge     OPTIONAL: not yet implemented.
%
%
%   TV3D calculates the total variation metric of a 3D data set by calculating
%   the following
%
%     tv = sum(abs(gradop * cube));
%
%   Calls: none.
%
%   Bugs: flgEdge not yet implemented.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: tv3d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tv, gradop] = tv3d(cube, dims, flgSparse)

if nargin < 2
    [nY nX nZ] = size(cube);
else
    nY = dims(1);
    nX = dims(2);
    nZ = dims(3);
end
cube = cube(:);

if nargin < 3
    flgSparse = 1;
end

%%
%%  Allocate the gradient operator for this size cube
%%
nROp = (nY-1) * nX * nZ + (nX-1) * nY * nZ + (nZ-1) * nX * nY;
nCOp = nX * nY * nZ;
if flgSparse
    gradop = sparse(nROp, nCOp);
else
    gradop = zeros(nROp, nCOp);
end

%%
%%  Y (down each column) derivative operator
%%
iRow = 1;
for iz = 1:nZ
    for ix = 1:nX
        for iy = 1:nY-1
            iLinear = iy + (ix - 1) * nY + (iz - 1) * nY * nX;
            gradop(iRow, iLinear) = -1;
            gradop(iRow, iLinear + 1) = 1;
            iRow = iRow + 1;
        end
    end
end

%%
%%  X (along each row) derivative operator
%%
for iz = 1:nZ
    for iy = 1:nY
        for ix = 1:nX-1
            iLinear = iy + (ix - 1) * nY + (iz - 1) * nY * nX;
            gradop(iRow, iLinear) = -1;
            gradop(iRow, iLinear + nY) = 1;
            iRow = iRow + 1;
        end
    end
end

%%
%%  Z (along each plane) derivative operator
%%
for iy = 1:nY
    for ix = 1:nX
        for iz = 1:nZ-1
            iLinear = iy + (ix - 1) * nY + (iz - 1) * nY * nX;
            gradop(iRow, iLinear) = -1;
            gradop(iRow, iLinear + nY*nX) = 1;
            iRow = iRow + 1;
        end
    end
end

%%
%%  Calculate the TV metric
%%
tv = sum(abs(gradop * cube));
