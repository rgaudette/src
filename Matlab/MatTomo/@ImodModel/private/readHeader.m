%readHeader     Read in the header of the ImodModel
%
%   imodModel = readHeader(imodModel, debug)
%
%   imodModel   The ImodModel object
%
%   debug       OPTIONAL: Print out debugging info (default: 0)
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:33:03 $
%
%  $Revision: 1.8 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = readHeader(imodModel, debug)

if nargin < 2
  debug = 0;
end
debugFD = 2;

if debug
  fprintf(debugFD, 'Reading ID tag and parsing version nubmer\n');
end

tag = char(fread(imodModel.fid, [1 8], 'uchar'));
if ~ strncmp(tag, 'IMOD', 4)
  imodModel = close(imodModel);
  error(' This is not an imod model file');
end
imodModel.name = char(fread(imodModel.fid, [1 128], 'uchar'));
% Find the zero terminator for the name
terms = find(imodModel.name == 0);
if ~ isempty(terms)
  nChar = terms(1);
  imodModel.name  = imodModel.name(1:nChar-1);
end
if debug
  disp(imodModel.name);
end

%  Read in the size and check for reasonable values
%  if not swap endianess
imodModel.xMax = fread(imodModel.fid, 1, 'int32');
imodModel.yMax = fread(imodModel.fid, 1, 'int32');
imodModel.zMax = fread(imodModel.fid, 1, 'int32');
imodModel.nObjects = fread(imodModel.fid, 1, 'int32');
imodModel.flags = fread(imodModel.fid, 1, 'int32');
imodModel.drawMode = fread(imodModel.fid, 1, 'int32');
imodModel.mouseMode = fread(imodModel.fid, 1, 'int32');
imodModel.blackLevel = fread(imodModel.fid, 1, 'int32');
imodModel.whiteLevel = fread(imodModel.fid, 1, 'int32');
imodModel.xOffset = fread(imodModel.fid, 1, 'float32');
imodModel.yOffset = fread(imodModel.fid, 1, 'float32');
imodModel.zOffset = fread(imodModel.fid, 1, 'float32');
imodModel.xScale = fread(imodModel.fid, 1, 'float32');
imodModel.yScale = fread(imodModel.fid, 1, 'float32');
imodModel.zScale = fread(imodModel.fid, 1, 'float32');
imodModel.object = fread(imodModel.fid, 1, 'int32');
imodModel.contour = fread(imodModel.fid, 1, 'int32');
imodModel.point = fread(imodModel.fid, 1, 'int32');
imodModel.res = fread(imodModel.fid, 1, 'int32');
imodModel.thresh = fread(imodModel.fid, 1, 'int32');
imodModel.pixelSize = fread(imodModel.fid, 1, 'float32');
imodModel.units = fread(imodModel.fid, 1, 'int32');
imodModel.csum = fread(imodModel.fid, 1, 'int32');
imodModel.alpha = fread(imodModel.fid, 1, 'int32');
imodModel.beta = fread(imodModel.fid, 1, 'int32');
imodModel.gamma = fread(imodModel.fid, 1, 'int32');

if debug
  fprintf('x max: %d\n', imodModel.xMax);
  fprintf('y max: %d\n', imodModel.yMax);
  fprintf('z max: %d\n', imodModel.zMax);
  fprintf('# objects: %d\n', imodModel.nObjects);
  fprintf('flags: 0x%08X\n', imodModel.flags);
  fprintf('draw mode: %d\n', imodModel.drawMode);
end

% FIXME need to add the ability to read global data chunks
[buffer nRead] = fread(imodModel.fid, [1 4], 'uchar');
iObj = 0;
iMat = 0;
while nRead > 0
  tag = char(buffer);
  if debug
    fprintf('TAG: %s\n', tag);
  end
  if strcmp(tag, 'OBJT')
    fseek(imodModel.fid, -4, 'cof');
    iObj = iObj + 1;    
    imodModel.Objects{iObj} = ImodObject;
    imodModel.Objects{iObj} = freadObject(imodModel.Objects{iObj}, imodModel.fid, debug);
    
    %FIXME read in IMAT objects and associate them with the particular
    % iObj

  elseif strcmp(tag, 'IMAT')
    iMat = iMat + 1;
    fseek(imodModel.fid, 20, 'cof');
    
  elseif strcmp(tag, 'MINX')
    iMat = iMat + 1;
    fseek(imodModel.fid, 76, 'cof');
    
  elseif strcmp(tag, 'IEOF')
    break;
    
  else
    warning(['Ignoring unknown object type: ' tag]);
    break;
  end
  [buffer nRead] = fread(imodModel.fid, [1 4], 'uchar');
end
imodModel = close(imodModel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: readHeader.m,v $
%  Revision 1.8  2005/05/08 17:33:03  rickg
%  Comment update
%
%  Revision 1.7  2005/03/02 22:38:37  rickg
%  Full hex flag display
%
%  Revision 1.6  2004/10/01 23:40:36  rickg
%  Removed warning about file already being closed
%
%  Revision 1.5  2004/09/18 20:46:49  rickg
%  Debugging info and help comments
%
%  Revision 1.4  2003/06/17 20:51:30  rickg
%  Added skip for MINX
%
%  Revision 1.3  2003/06/17 14:16:45  rickg
%  Get around reading IMATs need to implement
%
%  Revision 1.2  2003/03/04 05:36:52  rickg
%  Comment fix
%
%  Revision 1.1  2003/02/14 23:24:33  rickg
%  Initiail revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
