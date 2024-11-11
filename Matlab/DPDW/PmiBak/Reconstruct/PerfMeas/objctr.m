%OBJCTR         Compute the center of mass of an an object
%
%   ctr = objctr(objfct, CompVol, Thresh)
%
%   ctr         The estimate of the center of mass of the object [X Y Z].
%
%   objfct      The object function over the whole CompVol domain.  For
%               multiple object functions each one should be in a seperate
%               column.
%
%   CompVol     The computational volume data structure.
%
%   Thresh      OPTIONAL: The threshold coefficient to label between non-zero
%               and zero valued voxels.  This value is multiplied by the peak
%               value in the object function to compute the threshold level
%               (default: 0.5).
%
%
%   OBJCTR computes the weighted object center (center of mass) of the object(s)
%   present in objfct.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: objctr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ctr = objfct(objfct, CompVol, Thresh)

if nargin < 3
    Thresh = 0.5;
end

%%
%%  Find values of the object function(s) greater than the 
%%  Compute the center of mass for each object function
%%
nObjFct = size(objfct, 2);
ctr = zeros(3, nObjFct);


ThreshVal = max(objfct) * Thresh;
[X Y Z] = meshgrid(CompVol.X, CompVol.Y, CompVol.Z);
X = X(:); Y = Y(:); Z = Z(:);
for i = 1:nObjFct
    idxDet = objfct(:,i) > ThreshVal(i);
    detsum = sum(objfct(idxDet,i));
    ctr(1,i) = (objfct(idxDet,i)' * X(idxDet)) / detsum;
    ctr(2,i) = (objfct(idxDet,i)' * Y(idxDet)) / detsum;
    ctr(3,i) = (objfct(idxDet,i)' * Z(idxDet)) / detsum;
end
