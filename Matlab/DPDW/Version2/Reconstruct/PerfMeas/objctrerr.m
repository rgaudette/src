%OBJCTRERR      Compute the center of mass error for object function estimates.
%
%   err = objctrerr(xtrue, xest, CompVol, Thresh)
%
%   err         The computed error for each estimate.
%
%   xtrue       The true object function.
%
%   xest        The estimates to analyze.
%
%   CompVol     The computational volume data structure.
%
%   Thresh      OPTIONAL: The threshold coefficient to label between non-zero
%               and zero valued voxels.  This value is multiplied by the peak
%               value in the object function to compute the threshold level
%               (default: 0.5).
%
%
%   OBJCTRERR computes the weighted object center (center of mass) error for a
%   a number of object functions.
%
%   Calls: objctr
%
%   Bugs: none known.
function err = objctrerr(xtrue, xest, CompVol, Thresh)

nObjFct = size(xest, 2);

ctr_true = objctr(xtrue, CompVol, Thresh) * ones(1,nObjFct);

ctr_est = objctr(xest, CompVol, Thresh);

err = sqrt(sum((ctr_true - ctr_est) .^2));
