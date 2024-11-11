%freadObject  ImodObject file reader
%
%   imodObject = freadObject(imodObject, fid)
%
%   imodObject  The ImodObject
%
%   fid         A file ID of an open file with the pointer at the start of an
%               IMOD Object object.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 04:18:24 $
%
%  $Revision: 1.7 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodObject = freadObject(imodObject, fid, debug)

%  Check to make sure we have a Imod Object
ID = char(fread(fid, [1 4], 'uchar'));

if strncmp('OBJT', ID, 4) ~= 1
  error('This is not a IMOD Object object');
end

imodObject.name = char(fread(fid, [1 64], 'uchar'));
junk = char(fread(fid, [1 64], 'uchar'));
imodObject.nContours = fread(fid, 1, 'int32');
imodObject.flags = fread(fid, 1, 'uint32');
imodObject.axis = fread(fid, 1, 'int32');
imodObject.drawMode = fread(fid, 1, 'int32');
imodObject.red = fread(fid, 1, 'float32');
imodObject.green = fread(fid, 1, 'float32');
imodObject.blue = fread(fid, 1, 'float32');
imodObject.pdrawsize = fread(fid, 1, 'int32');

imodObject.symbol = fread(fid, 1, 'uchar');
imodObject.symbolSize = fread(fid, 1, 'uchar');
imodObject.lineWidth2D = fread(fid, 1, 'uchar');
imodObject.lineWidth3D = fread(fid, 1, 'uchar');
imodObject.lineStyle = fread(fid, 1, 'uchar');
imodObject.symbolFlags = fread(fid, 1, 'uchar');
imodObject.sympad = fread(fid, 1, 'uchar');
imodObject.transparency = fread(fid, 1, 'uchar');

imodObject.nMeshes = fread(fid, 1, 'int32');
imodObject.nSurfaces = fread(fid, 1, 'int32');

if debug
  fprintf('  Name: %s\n', imodObject.name);
  fprintf('  Contours: %d\n', imodObject.nContours);
  fprintf('  Meshes: %d\n', imodObject.nMeshes);
  fprintf('  Flags: 0x%08X\n', imodObject.flags);
end

%  Read in each of the specified objects
iContour = 1;
iMesh = 1;
iSurface = 1;
iChunk = 1;

while iContour <= imodObject.nContours | ...
      iMesh <= imodObject.nMeshes | ...
      iSurface <= imodObject.nSurfaces

  %  Read the ID string for the structure and rewind the file pointer
  id = char(fread(fid, [1 4], 'uchar'));
  fseek(fid, -4, 'cof');

  if debug
    fprintf('  TAG: %s\n', id);
  end 

  switch id
   
   case {'CONT'}
    imodContour = ImodContour;
    imodContour = freadContour(imodContour, fid, debug);
    imodObject.contour{iContour} = imodContour;
    iContour = iContour + 1;
    
   case{'MESH'}
    imodMesh = ImodMesh;
    imodMesh = freadMesh(imodMesh, fid, debug);
    imodObject.mesh{iMesh} = imodMesh;
    iMesh = iMesh + 1;
   
   % FIXME check logic to see if this works with multple objects.  If there
   % are multiple objects how do we know where this one ends, probably
   % reading an IOBJ tag
   case{'IEOF'}
    return
    
   otherwise
    imodChunk = ImodChunk;
    imodChunk = freadChunk(imodChunk, fid);
    %imodObject.chunk{iChunk} = imodChunk;
    iChunk = iChunk + 1;
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: freadObject.m,v $
%  Revision 1.7  2005/05/09 04:18:24  rickg
%  Comment update
%
%  Revision 1.6  2005/02/25 23:30:35  rickg
%  Print out flags in verbose mode
%
%  Revision 1.5  2004/10/01 23:36:03  rickg
%  Fixed string TAG reading
%
%  Revision 1.4  2004/09/18 20:49:35  rickg
%  Added debug section
%
%  Revision 1.3  2003/03/04 05:43:23  rickg
%  Added mesh and chunk reading
%
%  Revision 1.2  2003/02/22 00:46:35  rickg
%  Added contour reading
%
%  Revision 1.1  2003/02/14 23:33:18  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
