%ImodContour    ImodContour constructor
%
%   imodContour = ImodContour
%   imodContour = ImodContour(fid)
%   imodContour = ImodContour(imodContour)
%   imodContour = ImodContour(points)
%
%   imodContour The ImodContour object.
%
%   fid         A file ID of an open file with the pointer at the start of an
%               IMOD contour object.
%
%   points      The points of the contour in a 3 x N array.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/10 22:52:21 $
%
%  $Revision: 1.6 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodContour = ImodContour(varargin)

% Default constructor
if length(varargin) < 1
  imodContour = genImodContourStruct;
  imodContour = class(imodContour, 'ImodContour');
  return;
end


% If the argument is a double it is either a set of points or a file
% descriptor
if isa(varargin{1}, 'double')
  % Create the default object
  imodContour = genImodContourStruct;
  imodContour = class(imodContour, 'ImodContour');
  if numel(varargin{1}) == 1
    imodContour = freadContour(imodContour, varargin{1});
  else
    imodContour.points = varargin{1};
    imodContour.nPoints = size(varargin{1}, 2);
  end
elseif isa(varargin{1}, 'ImodContour')
  imodContour = varargin{1};
else
    error(['Unknown constructor argument ' class(varargin{1})]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: ImodContour.m,v $
%  Revision 1.6  2005/05/10 22:52:21  rickg
%  *** empty log message ***
%
%  Revision 1.5  2005/05/09 16:19:21  rickg
%  Comment updates
%
%  Revision 1.4  2005/05/09 15:56:10  rickg
%  Comment updates
%
%  Revision 1.3  2004/09/17 23:55:35  rickg
%  Instatiate a contour from points
%
%  Revision 1.2  2003/01/31 05:46:24  rickg
%  Comment fix
%
%  Revision 1.1  2003/01/11 18:30:00  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%