%write          Write the Imod model to a file
%
%   imodModel = write(imodModel, filename, verbose)
%
%   imodModel   The ImodModel object to write out.
%
%   filename    OPTIONAL: A new filename to write the object to (default:
%               the current ImodModel.filename
%
%   verbose     OPTIONAL: The amount of verbosity (default: 0).
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/06 22:05:57 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = write(imodModel, filename, verbose)

if nargin < 3
  verbose = 0;
end
if nargin > 1
  if verbose
    fprintf('Setting model filename to %s\n', filename);
  end
  imodModel = setFilename(imodModel, filename);
end

% Open the specified model file writable
if verbose
  fprintf('Switching the model file to writable\n');
end
imodModel.fid = openWritable(imodModel);

% Write out the model header
if verbose
  fprintf('Writing the header\n');
end
writeHeader(imodModel);

% Loop over each object writting it out to the file
for idxObject = 1:imodModel.nObjects
  if verbose
    fprintf('Writing object %d\n', idxObject);
  end
  write(imodModel.Objects{idxObject}, imodModel.fid);
end
writeAndCheck(imodModel.fid, 'IEOF', 'uchar');

if verbose
  fprintf('Closing the model\n');
end
imodModel = close(imodModel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: write.m,v $
%  Revision 1.3  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.2  2004/10/01 23:37:29  rickg
%  Improved verbose flag handling
%
%  Revision 1.1  2004/09/17 23:56:10  rickg
%  Initial revision
%
%  Revision 1.2  2003/03/04 05:37:23  rickg
%  Comment fix
%
%  Revision 1.1  2003/02/14 23:27:44  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
