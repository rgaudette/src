%freadChunk     ImodChunk file reader
%
%   imodChunk = freadChunk(imodChunk, fid)
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
%  $Date: 2005/05/09 16:19:21 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodChunk = freadChunk(imodChunk, fid)

%  Read in the tag since we may need to write it out again
imodChunk.ID = char(fread(fid, [1 4], 'uchar'));
fprintf('ID: %s\n', imodChunk.ID);
imodChunk.nBytes = fread(fid, 1, 'int32');
fprintf('# bytes: %d\n', imodChunk.nBytes);
imodChunk.bytes = fread(fid, imodChunk.nBytes, 'uchar=>uchar');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: freadChunk.m,v $
%  Revision 1.4  2005/05/09 16:19:21  rickg
%  Comment updates
%
%  Revision 1.3  2005/05/09 16:03:59  rickg
%  Comment updates
%
%  Revision 1.2  2004/10/01 23:36:03  rickg
%  Fixed string TAG reading
%
%  Revision 1.1  2003/03/04 05:34:49  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
