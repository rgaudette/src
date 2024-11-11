%freadMesh  ImodMesh file reader
%
%   imodMesh = freadMesh(imodMesh, fid)
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
%  $Date: 2005/06/24 22:43:59 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodMesh = freadMesh(imodMesh, fid, debug)

%  Check to make sure we have a Imod Mesh
ID = char(fread(fid, [1 4], 'uchar'));

if strncmp('MESH', ID, 4) ~= 1
  error('This is not a IMOD Mesh object');
end

imodMesh.nVertices = fread(fid, 1, 'int32');
imodMesh.nIndices = fread(fid, 1, 'int32');
imodMesh.flag = fread(fid, 1, 'int32');
imodMesh.type = fread(fid, 1, 'int16');
imodMesh.pad = fread(fid, 1, 'int16');
imodMesh.vertices = reshape(fread(fid, imodMesh.nVertices * 3, ...
                                'float32'),  3, imodMesh.nVertices);
imodMesh.indices = fread(fid, imodMesh.nIndices, 'int32');

if debug
  fprintf('    nVertices: %d\n', imodMesh.nVertices);
  fprintf('    nIndices: %d\n', imodMesh.nIndices);
  fprintf('    flag:  %d\n', imodMesh.flag);
  fprintf('    type:  %d\n', imodMesh.type);
  fprintf('    pad:  %d\n', imodMesh.pad);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: freadMesh.m,v $
%  Revision 1.4  2005/06/24 22:43:59  rickg
%  Added debug printing
%
%  Revision 1.3  2005/05/09 16:19:21  rickg
%  Comment updates
%
%  Revision 1.2  2004/10/01 23:36:03  rickg
%  Fixed string TAG reading
%
%  Revision 1.1  2003/03/04 05:35:31  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
