%ImodMesh    ImodMesh constructor
%
%   imodMesh = ImodMesh
%   imodMesh = ImodMesh(fid)
%   imodMesh = ImodMesh(imodMesh)
%
%   imodMesh    The ImodMesh object.
%
%   fid         A file ID of an open file with the pointer at the start of an
%               IMOD mesh object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 16:19:21 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodMesh = ImodMesh(varargin)

% Default constructor
if length(varargin) < 1
  imodMesh = genImodMeshStruct;
  imodMesh = class(imodMesh, 'ImodMesh');
  return;
end

% Single argument, if its a double it should be the file descriptor
% of with the pointer at the start of an Imod Mesh object if is
% another ImodMesh perform a copy construction
if length(varargin) == 1
  imodMesh = genImodMeshStruct;
  imodMesh = class(imodMesh, 'ImodMesh');
  if isa(varargin{1}, 'ImodMesh')
    imodMesh = varargin{1};
  else
    imodMesh = freadMesh(imodMesh, varargin{1});
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: ImodMesh.m,v $
%  Revision 1.2  2005/05/09 16:19:21  rickg
%  Comment updates
%
%  Revision 1.1  2003/03/04 05:35:31  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

