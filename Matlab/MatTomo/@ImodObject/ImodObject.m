%ImodObject    ImodObject constructor
%
%   imodObject = ImodObject
%   imodObject = ImodObject(fid)
%   imodObject = ImodObject(imodObject)
%
%   imodObject  The ImodObject
%
%   fid         A file descriptor of an open file with the pointer
%               at the start of an IMOD Object object.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 05:03:27 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodObject = ImodObject(varargin)

% Default constructor
if length(varargin) < 1
  imodObject = genImodObjectStruct;
  imodObject = class(imodObject, 'ImodObject');
  return;
end

% Single argument, if its a double it should be the file descriptor
% of with the pointer at the start of an Imod Contour object if is
% another ImodObject perform a copy construction
if length(varargin) == 1
  imodObject = genImodObjectStruct;
  imodObject = class(imodObject, 'ImodObject');
  if isa(varargin{1}, 'ImodObject')
    imodObject = varargin{1};
  else
    imodObject = freadObject(imodObject, fdes);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  $Log: ImodObject.m,v $
%  Revision 1.2  2005/05/09 05:03:27  rickg
%  Comment update
%
%  Revision 1.1  2003/01/31 05:45:44  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
