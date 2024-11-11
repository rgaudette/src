%open           Read the Imod model specified in the file
%
%   imodModel = open(imodModel, filename, verbose)
%
%   imodModel   The ImodModel object.
%
%   filename    A string containing the name of the Imod model to load.
%
%   verbose     OPTIONAL: The amount of verbosity (default: 0).
%
%
%   ImodModel.open will load in the Imod model specified by the supplied file
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:33:18 $
%
%  $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = open(imodModel, filename, verbose)

if nargin < 3
  verbose = 0;
end

% Check to see a the file is already open
if ~ isempty(imodModel.fid)
  error(...
    'A IMOD modelfile is already open, close it before trying to reuse this object');
  return
end

% Open the file read-only, save the fid for future access
% IMOD models are always big endian!
imodModel.endianFormat = 'ieee-be';
[fid msg]= fopen(filename, 'r', imodModel.endianFormat);
if fid ~= -1
  imodModel.fid = fid;
  imodModel.filename = filename;
  [imodModel] = readHeader(imodModel, verbose);
else
  error('Unable to open file: %s\nReason: %s', filename, msg);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: open.m,v $
%  Revision 1.5  2005/05/08 17:33:18  rickg
%  Comment update
%
%  Revision 1.4  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.3  2005/01/29 00:33:12  rickg
%  Better error reporting
%
%  Revision 1.2  2003/03/04 05:37:23  rickg
%  Comment fix
%
%  Revision 1.1  2003/02/14 23:27:44  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
