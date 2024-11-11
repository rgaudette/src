%TV2D           Calculate the total variation for a 2D dataset (image)
%
%   [tv gradop] = tv2d(image, dims, flgEdge)
%
%   tv          The total variation for the image. 
%
%   gradop      The gradient operator.
%
%   image       The image data to evaluate 
%
%   dims        OPTIONAL: The dimensions of the image if it is in vector format.
%
%   flgSparse   OPTIONAL: Use a sparse matrix representation of the gradient
%               operator (default: 1).
%
%   flgEdge     OPTIONAL: not yet implemented.
%
%
%   TV2D calculates the total variation metric of a 2D data set by calculating
%   the following
%
%     tv = sum(abs(gradop * image));
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
%  $Log: tv2d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tv, gradop] = tv2d(image, dims, flgSparse)

if nargin < 2
    [nY nX] = size(image);
else
    nY = dims(1);
    nX = dims(2);
end
image = image(:);

if nargin < 3
    flgSparse = 1;
end

%%
%%  Allocate the gradient operator for this size image
%%
if flgSparse
    gradop = sparse((nY-1) * nX + (nX-1) * nY, nX * nY);
else
    gradop = zeros((nY-1) * nX + (nX-1) * nY, nX * nY);
end

%%
%%  Y (down each column) derivative operator
%%
iRow = 1;
for ix = 1:nX
    for iy = 1:nY-1
        iLinear = iy + (ix - 1) * nY;
        gradop(iRow, iLinear) = -1;
        gradop(iRow, iLinear + 1) = 1;
        iRow = iRow + 1;
    end
end

%%
%%  X (along each row) derivative operator
%%
for iy = 1:nY
    for ix = 1:nX-1
        iLinear = iy + (ix - 1) * nY;
        gradop(iRow, iLinear) = -1;
        gradop(iRow, iLinear + nY) = 1;
        iRow = iRow + 1;
    end
end

%%
%%  Calculate the TV metric
%%
tv = sum(abs(gradop * image));
