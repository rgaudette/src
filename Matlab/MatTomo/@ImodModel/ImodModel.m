%ImodModel      Imod model constructor
%
%   imodModel = ImodModel
%   imodModel = ImodModel(filename, flgVerbose)
%   imodModel = ImodModel(pointArray)
%
%   imodModel   The constructed ImodModel object.
%
%   filename    OPTIONAL: A string containing the name of the Imod model to
%               load.
%
%   pointArray  OPTIONAL: An array of 3D points to use for initializing the
%               model (3xN)
%
%
%   ImodModel instantiates a new ImodModel object.  If a filename is
%   supplied the ImodModel is initialized from that file.  If an array of points
%   is supplied then a model with one object and one contour containing those
%   points is constructed.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:33:18 $
%
%  $Revision: 1.9 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = ImodModel(varargin)

% Default constructor
if length(varargin) < 1
  imodModel = genImodModelStruct;
  imodModel = class(imodModel, 'ImodModel');
  return;
end
flgDebug = 0;

if ischar(varargin{1})
  % If its a string it should be the name of the
  % MRCImage file, if it is another MRCImage then do a copy
  if nargin > 1
    flgDebug = varargin{2};
  end
  imodModel = genImodModelStruct;
  imodModel = class(imodModel, 'ImodModel');
  imodModel = open(imodModel, varargin{1}, flgDebug);
  
elseif isnumeric(varargin{1})
  % If it is numeric it should be an 3xN array of points
  imodModel = genImodModelStruct;
  imodModel = class(imodModel, 'ImodModel');
  imodModel = appendObject(imodModel, appendContour(ImodObject, ImodContour(varargin{1})));
  
elseif isa(varargin{1}, 'ImodModel');
  % Copy constructor
  imodModel = varargin{1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: ImodModel.m,v $
%  Revision 1.9  2005/05/08 17:33:18  rickg
%  Comment update
%
%  Revision 1.8  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.7  2005/02/25 23:29:47  rickg
%  Header text update
%
%  Revision 1.6  2004/10/20 22:49:18  rickg
%  Added construction with point array
%
%  Revision 1.5  2004/10/01 23:37:29  rickg
%  Improved debug flag handling
%
%  Revision 1.4  2004/09/27 23:53:18  rickg
%  Removed default debugging output
%
%  Revision 1.3  2004/09/18 20:49:06  rickg
%  Help text
%
%  Revision 1.2  2003/02/14 23:26:19  rickg
%  Corrected structure initialization and class ID
%  Corrected open call
%
%  Revision 1.1  2003/01/11 18:36:09  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
