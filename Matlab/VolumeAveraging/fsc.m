%fsc            Fourier shell correlation
%
%   [fscc, nSamples] = fscc(vol1, vol2, fShells, ...
%     windowName, windowParams, windowCenter)
%
%   fscc        The Fourier shell correlation coefficient for each shell
%
%   nSamples    The number of samples used for each shell
%
%   vol1, vol2  The volumes to compare
%
%   fShells     The upper frequency limit of each shell, in discrete
%               frequency units.
%
%   winName     OPTIONAL: The name of the window to apply to the volume data.
%               'gaussian' (default)
%
%   winParams   OPTIONAL: The parameters to pass to the window generation function.
%               For a gaussian window the parameters are [radius sigma] see
%               gaussianMask.
%
%   winCenter   OPTIONAL: The center of the mask window (default: [ ], the ...
%               volume center)
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/12 16:35:30 $
%
%  $Revision: 1.7 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fscc, nSamples] = fsc(vol1, vol2, fShells, ...
  winName, winParams, winCenter)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: fsc.m,v 1.7 2005/10/12 16:35:30 rickg Exp $\n');
end

if nargin < 4
  flgWindow = 0;
else
  flgWindow = 1;
end

szVol1 = size(vol1);
szVol2 = size(vol2);
if any(szVol1 ~= szVol2)
  error('Both volumes must be the same size')
end

nX = szVol1(1);
nY = szVol1(2);
nZ = szVol1(3);
fX = ([0:nX-1] - floor(nX / 2)) / nX;
fY = ([0:nY-1] - floor(nY / 2)) / nY;
fZ = ([0:nZ-1] - floor(nZ / 2)) / nY;

[arrFX arrFY arrFZ] = ndgrid(fX', fY, fZ);

fMag = sqrt(arrFX.^2 + arrFY.^2 + arrFZ.^2);

nShells = length(fShells);
fscc = zeros(nShells, 1);
nSamples = zeros(nShells, 1);
fLow = [0 fShells(1:end-1)];

% Create the selected data window
if flgWindow == 1
  switch winName
    case 'gaussian'
      win = gaussianMask(szVol1, winParams(1), winParams(2), winCenter);

    otherwise
      if isempty(winParams)
        winX = eval(['window(@' winName ', ' int2str(szVol1(1)), ')' ]);
        winY = eval(['window(@' winName ', ' int2str(szVol1(2)), ')' ]);
        winZ = eval(['window(@' winName ', ' int2str(szVol1(3)), ')' ]);
      else
        winX = eval(['window(@' winName ', ' int2str(szVol1(1)), ', ' ...
          num2str(winParams) ')' ]);
        winY = eval(['window(@' winName ', ' int2str(szVol1(2)), ', ' ...
          num2str(winParams) ')' ]);
        winZ = eval(['window(@' winName ', ' int2str(szVol1(3)), ', ' ...
          num2str(winParams) ')' ]);
      end
      [hX hY hZ] = ndgrid(winX', winY, winZ);
      win = hX .* hY .* hZ;
  end
  vol1 = win .* vol1;
  vol2 = win .* vol2;
end

VOL1 = fftshift(fftn(vol1));
VOL2 = fftshift(fftn(vol2));

for iShell = 1:nShells
  % Find the samples in the current shell
  idxShell = (fMag >= fLow(iShell)) & (fMag < fShells(iShell));
  idxShell = idxShell(:);
  shell1 = VOL1(idxShell);
  shell2 = VOL2(idxShell);
  
  % Compute the cross correlation of the pair of images in the shell
  nrgShell1 = sum(abs(shell1) .^2);
  nrgShell2 = sum(abs(shell2) .^2);
  fscc(iShell) = abs(shell1' * shell2) / sqrt(nrgShell1 .* nrgShell2);
  nSamples(iShell) = sum(idxShell);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: fsc.m,v $
%  Revision 1.7  2005/10/12 16:35:30  rickg
%  Comment updates
%  window handling
%
%  Revision 1.6  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.5  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.4  2005/03/02 22:41:32  rickg
%  Added gaussian windowing with parameters
%
%  Revision 1.3  2004/11/17 00:28:39  rickg
%  Added hamming window capability
%
%  Revision 1.2  2004/11/02 22:06:42  rickg
%  Inital revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
