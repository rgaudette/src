%wavedec3       Compute the separable 3D wavelet decomposition of a cube
%
%   wtCoeffs = wavedec3(cube, nScales, 'wavelet')
%
%   result      Output description
%
%   parm        Input description [units: MKS]
%
%   Optional    OPTIONAL: This parameter is optional (default: value)
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none
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
%  $Log: wavedec3.m,v $
%  Revision 1.1  2004/03/05 00:58:54  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function wtCoeffs = wavedec3(cube, nScales, wavelet)


% Loop over each scale Computing the 3D wavelet transform at that scale
approx = cube;
for iScale = 1:nScales
  [approx details] = dwt3(approx, wavelet);
  wtCoeffs{iScale} = details;
end
wtCoeffs{iScale+1} = approx;
