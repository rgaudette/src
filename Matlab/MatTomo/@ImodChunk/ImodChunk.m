%ImodChunk    ImodChunk constructor
%
%   imodChunk = ImodChunk
%   imodChunk = ImodChunk(fid)
%   imodChunk = ImodChunk(imodChunk)
%
%   imodChunk   The ImodChunk object.
%
%   fid         A file ID of an open file with the pointer at the start of an
%               IMOD chunk object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 16:03:59 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodChunk = ImodChunk(varargin)

% Default constructor
if length(varargin) < 1
  imodChunk = genImodChunkStruct;
  imodChunk = class(imodChunk, 'ImodChunk');
  return;
end

% Single argument, if its a double it should be the file descriptor
% of with the pointer at the start of an Imod Chunk object if is
% another ImodChunk perform a copy construction
if length(varargin) == 1
  imodChunk = genImodChunkStruct;
  imodChunk = class(imodChunk, 'ImodChunk');
  if isa(varargin{1}, 'ImodChunk')
    imodChunk = varargin{1};
  else
    imodChunk = freadChunk(imodChunk, varargin{1});
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: ImodChunk.m,v $
%  Revision 1.2  2005/05/09 16:03:59  rickg
%  Comment updates
%
%  Revision 1.1  2003/03/04 05:34:49  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
