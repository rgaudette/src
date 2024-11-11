%splitMOTL_FSC  Split motive list fourier shell correlation
%
%   [arrFSCC, arrNFSCC] = splitMOTL_FSC(volume, imodParticle, szVol, ...
%                                       sAlign, fShells, nEstimate)
%
%   arrFSCC     The array of Fourier shell correlation coefficients
%
%   arrNFSCC    The number of samples used for each shell.
%
%   volume      The MRCImage volume containing the particles.
%
%   imodParticle The ImodModel specifying the particle location centers.
%
%   szVol       The size of the volume to calculate and analyze.
%
%   sAlign      The alignment struct to split.
%
%   freqShells  The upper frequency limit of each shell, in discrete
%               frequency units.
%
%   nParticles  A vector containing the number of particles to
%               use from each population.
%
%   tiltRange   OPTIONAL: The minimum and maximum of the tilt axis (default: [ ]
%               don't compensate for the missing wedge)
%
%   edgeShift   OPTIONAL: The number of pixels shift the edge of the wedge
%               mask to ensure that all of the frequency info is included
%               (default: 0).
%
%   fnHalfVolume  OPTIONAL: The base name of the half volumes to write out
%               (deault: '', don't write out the half volumes).
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/24 21:55:20 $
%
%  $Revision: 1.13 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [arrFSCC, arrNFSCC] = splitMOTL_FSC(...
  volume, imodParticle, szVol, sAlign, freqShells, ...
  nParticles, winName, winParams, winCenter, tiltRange, ...
  edgeShift, fnHalfVolume, flgVerbose)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: splitMOTL_FSC.m,v 1.13 2005/10/24 21:55:20 rickg Exp $\n');
end

if nargin < 10
  tiltRange = [ ];
end

if nargin < 11
  edgeShift = 0;
end

if nargin < 12
  fnHalfVolume = '';
end

if nargin < 13
  flgVerbose = 0;
end

% Hardcoded parameters
flgMeanFill = 1;

nShells = length(freqShells);
nCount = length(nParticles);

arrFSCC = zeros(nShells, nCount);
arrNFSCC = zeros(nShells, nCount);
oddMotiveList = sAlign(:, 1:2:end);
evenMotiveList = sAlign(:, 2:2:end);
nHalf = size(evenMotiveList, 2);

evenVol = [ ];
oddVol = [ ];
lastCount = 0;

for iCount = 1:nCount
  if nParticles(iCount) > nHalf
    fprintf('%d is greater than half of the particles.\n',  nParticles(iCount));
    break;
  end
  
  if isempty(tiltRange)
    evenVol = motlAverage3(volume, imodParticle, szVol, evenMotiveList, ...
      nParticles(iCount), [], [], [], flgMeanFill, '', evenVol, lastCount, ...
      flgVerbose);
    oddVol = motlAverage3(volume, imodParticle, szVol, oddMotiveList, ...
      nParticles(iCount), [], [], [], flgMeanFill, '', oddVol, lastCount, ...
      flgVerbose);
  else
    evenVol = motlAverage5( ...
      volume, imodParticle, szVol, evenMotiveList, nParticles(iCount), ...
      tiltRange, edgeShift, [], [], [], ...
      flgMeanFill, '', [], [], [], flgVerbose);
    oddVol = motlAverage5(... 
      volume, imodParticle, szVol, oddMotiveList, nParticles(iCount), ...
      tiltRange, edgeShift, [], [], [], ...
      flgMeanFill, '', [], [], [], flgVerbose);
  end
  evenVol = evenVol - mean(evenVol(:));
  oddVol = oddVol - mean(oddVol(:));
  
  % Write out the even and odd volumes if a basename is provided
  if ~ isempty(fnHalfVolume)
    evenFilename = sprintf('%s_even_%03d.mrc', fnHalfVolume ,nParticles(iCount));
    save(MRCImage(evenVol), evenFilename);
    
    oddFilename = sprintf('%s_odd_%03d.mrc', fnHalfVolume, nParticles(iCount));
    save(MRCImage(oddVol), oddFilename);
  end
  
  [arrFSCC(:, iCount) arrNFSCC(:, iCount)] = fsc(oddVol, evenVol, freqShells, ...
    winName, winParams, winCenter);
  lastCount = nParticles(iCount);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: splitMOTL_FSC.m,v $
%  Revision 1.13  2005/10/24 21:55:20  rickg
%  Comment fix
%
%  Revision 1.12  2005/10/12 16:38:52  rickg
%  Restructured call sig
%
%  Revision 1.11  2005/08/26 23:10:32  rickg
%  Updated for new average functions
%
%  Revision 1.10  2005/08/15 23:17:37  rickg
%  Type fix
%
%  Revision 1.9  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.8  2005/03/02 22:41:32  rickg
%  Added gaussian windowing with parameters
%
%  Revision 1.7  2005/02/10 19:34:54  rickg
%  Function name update
%
%  Revision 1.6  2004/12/15 00:55:00  rickg
%  Added ability to write out odd and even volumes
%
%  Revision 1.5  2004/12/08 23:35:20  rickg
%  Basic missing wedge handling
%
%  Revision 1.4  2004/11/17 00:30:35  rickg
%  Added hamming window capability
%
%  Revision 1.3  2004/11/05 19:43:59  rickg
%  Corrected mapping to output arrays
%
%  Revision 1.2  2004/11/02 23:29:31  rickg
%  Added nEstimate option
%
%  Revision 1.1  2004/11/02 23:20:21  rickg
%  Inital revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

