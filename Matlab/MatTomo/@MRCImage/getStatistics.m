%getStatistics  Return the selected statistic(s) of the volume
%
%   stat = getStatistics(mRCImage, statistic, domain)
%
%   stat        The requested statistic(s)
%
%   mRCImage    The mRCImage object to analyze.
%
%   statistic   The statistic to calculate:
%               'min', 'max', 'mean', 'median'
%
%   domain      OPTIONAL: The domain over which the statistic will be
%               calculated: ('z')
%               'x', 'y', 'z', 'global'
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:05 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stat = getStatistics(mRCImage, statistic, domain)
this=mRCImage;

%  Permute/stack the data if according to the domain selection
if nargin < 3
  domain = 'z';
end

switch lower(domain)
 case 'x'
    data = reshape(permute(this.volume, [2 3 1]), ...
                   this.header.nY * this.header.nZ, ...
                   this.header.nX);
 case 'y'
    data = reshape(permute(this.volume, [1 3 2]), ...
                   this.header.nX * this.header.nZ, ...
                   this.header.nY);
 case 'z'
   data = reshape(this.volume, this.header.nX * this.header.nY, ...
                  this.header.nZ);
 case 'global'
  data = this.volume(:);
 
 otherwise
  error(['Invalid domain selector: ' domain]);
end


switch lower(statistic)
 case 'min'
  stat = min(data);
 
 case 'max'
   stat = max(data);
 
 case 'mean',
   stat = mean(data);
 
 case 'std',
   stat = std(data);
 
 case 'median',
    stat = median(data);
 
 otherwise
  error(['Unimplemented statistic: ' statistic]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getStatistics.m,v $
%  Revision 1.2  2005/05/09 17:47:05  rickg
%  Comment updates
%
%  Revision 1.1  2003/06/17 14:15:13  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
