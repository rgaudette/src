%calcStatistics  Calculate and update the statistics in the MRCImage
%
%   mRCImage = calcStatistics(mRCImage)
%
%   mRCImage    The MRCImage object
%
%
%   Calcualte the volume statistics and update the header information
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:04 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = calcStatistics(mRCImage)

if mRCImage.flgVolume
  mRCImage.header.minDensity = min(mRCImage.volume(:));
  mRCImage.header.maxDensity = max(mRCImage.volume(:));
  mRCImage.header.meanDensity = mean(mRCImage.volume(:));
  mRCImage.header.densityRMS = std(mRCImage.volume(:));
else
  error('Not yet implemented for MRCImage file');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: calcStatistics.m,v $
%  Revision 1.2  2005/05/09 17:47:04  rickg
%  Comment updates
%
%  Revision 1.1  2004/09/17 16:44:40  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
