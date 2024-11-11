%openWritable   (Re)open the file to be writable creating it if necessary.
%
%   fid = openWritable(imodModel)
%
%   fid         The file ID of the opened file.
%
%   imodModel   The ImodModel object.
%
%
%   openWritable open or reopens the file as writable, creating the file if
%   it does not exist yet.  The file ID of the opened file is returned.  The
%   file is specified in the ImodModel.filename field.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:33:03 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fid = openWritable(imodModel)

% Check to see if the file exists
result = dir(imodModel.filename);
if size(result, 1) > 0
  % file does exist (re)open it r+, we don't want to open it w+ because that
  % will truncate it
  format = 'r+';
else 
  % The file doesn't exist open it w+
  format = 'w+';
  
  % Failsafe, this shouldn't happen
  if ~ isempty(imodModel.fid)
    disp('Found an FID in an ImodModel object that did not have a filename');
    warning(...
      'Closing stale FID, this may be incorrect and close another object');
    close(imodModel);
  end
end

% Check to see if the file is already open
if isempty(imodModel.fid)
  [fid msg]= fopen(imodModel.filename, format, imodModel.endianFormat);
  if fid == -1
    disp(msg)
    error(['Unable to open ' imodModel.filename ' as ' format]);
  end

else
  [name permission] = fopen(imodModel.fid);
  switch permission
   case {'r', 'a', 'a+'}
    % Close and reopen the file to get a writable mode
    fclose(imodModel.fid);
    [fid msg]= fopen(imodModel.filename, format, imodModel.endianFormat);
    if fid == -1
      disp(msg)
      error(['Unable to reopen ' imodModel.filename ' as ' format]);
    end
   
   otherwise
    % The file is already open for writing, just return the current fid
    fid = imodModel.fid;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: openWritable.m,v $
%  Revision 1.3  2005/05/08 17:33:03  rickg
%  Comment update
%
%  Revision 1.2  2004/11/23 00:42:14  rickg
%  Use dir to check for file existence
%
%  Revision 1.1  2004/09/18 00:02:41  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
