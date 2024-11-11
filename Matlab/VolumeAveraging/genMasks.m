%genMasks      Construct the volume mask and the xcorrelation valid region mask
%
%  [volMask, xcfMask] = genMasks(szVol, searchRadius, posCenter, classname)
%
%  volMask     The mask to apply to one of the volumes to prevent aliasing in
%              the circulant convolution.  This mask is one over the range:
%                 searchRadius(i)+1:end-searchRadius(i)
%
%  xcfMask     The mask that identifies valid cross-correlation function
%              coefficients.  This mask is one over the range:
%              [-searchRadius(i)-1:searchRadius(i)+1] + idxXCFOrigin(i)
%
%  szArray     The size of the arrays to be cross-correlated.
%
%  searchRadius  The number of pixels to be search in each dimension.  Each
%              element specifies the radius of search in the respective
%              dimension.  The [1 2 3] would specify a [-1:1] shift in X,
%              [-2:2] shift in Y, and [-3:3] shift in Z.
%
%  posCenter   OPTIONAL: The index of the zero shift cross-correlation
%              value.  If not specified or [] then it defaults to
%              floor(szArray/2) + 1.
%
%  classname   OPTIONAL: A string specifying the data to type to return
%              (default: 'double').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.7 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [volMask, xcfMask] = genMasks(szArray, searchRadius, idxXCFOrigin, classname)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: genMasks.m,v 1.7 2005/08/15 23:17:36 rickg Exp $\n');
end

if nargin < 3 || isempty(idxXCFOrigin)
  idxXCFOrigin = floor(szArray/2) + 1;
end
if nargin < 4
  classname = 'double';
end

% Create the appropriately dimensioned masks
switch length(szArray)
  case 1
    volMask = ones([szArray 1], classname);
    volMask([1:searchRadius(1) end-searchRadius(1)+1:end]) = 0;
    xcfMask = zeros([szArray 1], classname);
    xcfMask([-searchRadius(1)+1:searchRadius(1)-1] + idxXCFOrigin(1)) = 1;

  case 2
    volMask = ones(szArray, classname);
    volMask([1:searchRadius(1) end-searchRadius(1)+1:end], :) = 0;
    volMask(:, [1:searchRadius(2) end-searchRadius(2)+1:end]) = 0;
    xcfMask = zeros(szArray, classname);
    xcfMask(...
      idxXCFOrigin(1) + [-searchRadius(1)+1:searchRadius(1)-1], ...
      idxXCFOrigin(2) + [-searchRadius(2)+1:searchRadius(2)-1]) = 1;

  case 3
    volMask = ones(szArray, classname);
    volMask([1:searchRadius(1) end-searchRadius(1)+1:end], :, :) = 0;
    volMask(:, [1:searchRadius(2) end-searchRadius(2)+1:end], :) = 0;
    volMask(:, :, [1:searchRadius(3) end-searchRadius(3)+1:end]) = 0;
    xcfMask = zeros(szArray, classname);
    xcfMask(...
      idxXCFOrigin(1) + [-searchRadius(1)+1:searchRadius(1)-1], ...
      idxXCFOrigin(2) + [-searchRadius(2)+1:searchRadius(2)-1], ...
      idxXCFOrigin(3) + [-searchRadius(3)+1:searchRadius(3)-1]) = 1;
  otherwise
    error('%d dimensional mask not yet implemented\n', length(szArray))
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: genMasks.m,v $
%  Revision 1.7  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.6  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.5  2004/12/16 00:59:09  rickg
%  *** empty log message ***
%
%  Revision 1.4  2004/10/26 17:04:43  rickg
%  Updated help
%  Implemented 1 & 2 dimensional masks
%
%  Revision 1.3  2004/09/15 21:22:41  rickg
%  Help section
%  Default arg for idxXCFOrigin
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
