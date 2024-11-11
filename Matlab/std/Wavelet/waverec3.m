%waverec3       Compute the separable 3D wavelet reconstruction  of a cube
%
%   rec = waverec3(wtCoeffs, 'wavelet')
%
%
%   waverec3 reconstructs a 3D data cube from the specified wavelet
%   coefficients.
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
%  $Log: waverec3.m,v $
%  Revision 1.1  2004/03/05 00:58:54  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rec = waverec3(wtCoeffs, wavelet)

nScales = length(wtCoeffs) - 1;

approx = wtCoeffs{nScales + 1};
for iScale = nScales:-1:1
  approx = idwt3(approx, wtCoeffs{iScale}, wavelet);
end

rec = approx;
