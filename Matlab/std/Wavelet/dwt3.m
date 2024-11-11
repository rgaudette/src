%dwt3           Single level discrete 3-D wavelet transform.
%
%   [AAA AAD ADA ADD DAA DAD DDA DDD] = dwt3(cube, 'wavelet')
%   coefCube = dwt3(cube, 'wavelet');

%   AAA ... DDD The approximation and detail cubes, the three characters
%               represent how the approximation and detail filters are applied.
%               The first character represents the filter applied along the
%               rows, the second represents the columns filter and the third
%               character is for the plane filter.
%
%   coefCube    The approximation and detail cubes returned as structure with
%               field names the same as above, i.e. coefCube.AAA
%
%   cube        The data cube to be decomposed.
%
%   'wavelet'   The wavelet to use.
%
%
%   dwt3 computes the 3 dimensional separable wavelet transform of the 3D
%   array cube.
%
%   Calls: dwt2, dwt, 
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/03/05 00:58:54 $
%
%  $Revision: 1.1 $
%
%  $Log: dwt3.m,v $
%  Revision 1.1  2004/03/05 00:58:54  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [AAA, AAD, ADA, ADD, DAA, DAD, DDA, DDD] = dwt3(cube, wavelet)

% Precompute the filter coefficients
[loDecomp hiDecomp] = wfilters(wavelet, 'd');

nPlanes = size(cube, 3);
% Compute the 2D WT for each plane in the cube
for iPlane = nPlanes:-1:1
  [aa(:,:,iPlane) ad(:,:,iPlane) da(:,:,iPlane) dd(:,:,iPlane)] = ...
      dwt2(cube(:,:,iPlane), loDecomp, hiDecomp);
end

% Compute the 1D DWT along the plane dimension for each image element
nRows = size(aa, 1);
nColumns = size(aa, 2);
for iRow = nRows:-1:1
  for iCol = nColumns:-1:1
    [AAA(iRow, iCol, :) AAD(iRow, iCol, :)] = ...
        dwt(aa(iRow, iCol, :), loDecomp, hiDecomp);
    [ADA(iRow, iCol, :) ADD(iRow, iCol, :)] = ...
        dwt(ad(iRow, iCol, :), loDecomp, hiDecomp);
    [DAA(iRow, iCol, :) DAD(iRow, iCol, :)] = ...
        dwt(da(iRow, iCol, :), loDecomp, hiDecomp);
    [DDA(iRow, iCol, :) DDD(iRow, iCol, :)] = ...
        dwt(dd(iRow, iCol, :), loDecomp, hiDecomp);
  end
end

% FIXME: use nargout, varargout
if nargout == 1
  coefCube.AAA = AAA;
  coefCube.AAD = AAD;
  coefCube.ADA = ADA;
  coefCube.ADD = ADD;
  coefCube.DAA = DAA;
  coefCube.DAD = DAD;
  coefCube.DDA = DDA;
  coefCube.DDD = DDD;
  AAA = coefCube;
end

if nargout == 2
  coefCube.AAD = AAD;
  coefCube.ADA = ADA;
  coefCube.ADD = ADD;
  coefCube.DAA = DAA;
  coefCube.DAD = DAD;
  coefCube.DDA = DDA;
  coefCube.DDD = DDD;
  AAD = coefCube;
end
