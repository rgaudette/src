%EM2MRC         Convert and EM file or structure to MRCImage file or object
%
%   em2mrc(emFilename, MRCFilename)
%   em2mrc(emStruct, MRCFilename)
%   mRCImage = em2mrc(emFilename);
%   mRCImage = em2mrc(emStruct);
%
%   mRCImage    OPTIONAL: MRCImage object
%
%   emFilename  A string containing the name of the EM file.
%
%   emSruct     An EM structure as defined by the TOM toolbox
%
%   MRCFilename A string containing the name of the MRC file to write out
%
%
%   em2mrc will convert an EM file or structure to an MRCImage file or
%   object.  If no output argument is specified two arguments need to be
%   specified.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:12:05 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = em2mrc(varargin)

% Get the data volume from the EM object
if isa(varargin{1}, 'char')
  em = tom_emread(varargin{1});
  volume = em.Value;
elseif isa(varargin{1}, 'struct')
  volume = varargin{1}.Value;
else
  error('The first argument should be either a filename or a EM struct');
end

% TODO force the volume to a specific data type
mRCImage = MRCImage(volume);
if nargin > 1
  save(mRCImage, varargin{2});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: em2mrc.m,v $
%  Revision 1.2  2005/05/09 17:12:05  rickg
%  Comment updates
%
%  Revision 1.1  2004/07/20 20:21:17  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

