%MRCImage        MRCImage Constructor 
%
%   mRCImage = MRCImage
%   mRCImage = MRCImage(filename)
%   mRCImage = MRCImage(filename, flgLoad)
%   mRCImage = MRCImage(header)
%   mRCImage = MRCImage(header, filename)
%   mRCImage = MRCImage(header, filename, flgLoad)
%   mRCImage = MRCImage(volume)
%   mRCImage = MRCImage(MRCImage)
%   mRCImage = MRCImage(MRCImage, fileName)
%
%   mRCImage    The constructed MRCImage object
%
%   fileName    The name of an MRC image file to use in initializing the
%               object.
%
%   flgLoad     A flag specifying whether to load the volume into memory.
%               (default: 1, load volume).
%
%   header      A header for creating an empty (zeroed) volume.
%
%
%   MRCImage constructs an MRCImage object and optionally initializes it
%   with the specified MRC image file.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:05 $
%
%  $Revision: 1.13 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = MRCImage(varargin)

% Create a default MRCImage image structure
mRCImage = default;
mRCImage = class(mRCImage, 'MRCImage');    

% Default constructor
if length(varargin) < 1
  return;
end


% Decide which type of constructor is being called
% - if the first argument is a string it should be the name of the MRCImage
%   file
% - if the first argument is a struct it is (partial) header and create a
%   zeroed volume
% - if the first argument is another MRCImage then do a copy
if isa(varargin{1}, 'char')
  if length(varargin) < 2
    mRCImage = open(mRCImage, varargin{1});
  else
    mRCImage = open(mRCImage, varargin{1}, varargin{2});
  end

elseif isa(varargin{1}, 'struct')
  if nargin > 2
    flgLoad = varargin{3};
  else
    flgLoad = 1;
  end
  mRCImage = emptyVolume(mRCImage, varargin{1}, varargin{2}, flgLoad);
  
elseif isa(varargin{1}, 'numeric')
  if isa(varargin{1}, 'uint8')
    mRCImage.header.mode = 0;
    mRCImage.volume = varargin{1};
  end
  if isa(varargin{1}, 'int16')
    mRCImage.header.mode = 1;
    mRCImage.volume = varargin{1};
  end
  if isa(varargin{1}, 'single')
    mRCImage.header.mode = 2;
    mRCImage.volume = varargin{1};
  end
  if isa(varargin{1}, 'double')
    mRCImage.header.mode = 2;
    mRCImage.volume = single(varargin{1});
  end
  

  %%  Create a default MRCImage object and set the volume to the supplied data
  %%  TODO: is this the correct/best way to set the values
  mRCImage.header.nX = size(varargin{1}, 1);
  mRCImage.header.nY = size(varargin{1}, 2);
  mRCImage.header.nZ = size(varargin{1}, 3);
  mRCImage.header.nXStart = 0;
  mRCImage.header.nYStart = 0;
  mRCImage.header.nZStart = 0;
  mRCImage.header.mX = 1;
  mRCImage.header.mY = 1;
  mRCImage.header.mZ = 1;
  mRCImage.header.cellDimensionX = 1;
  mRCImage.header.cellDimensionY = 1;
  mRCImage.header.cellDimensionZ = 1;
  mRCImage.header.cellAngleX = 0;
  mRCImage.header.cellAngleY = 0;
  mRCImage.header.cellAngleZ = 0;

  mRCImage.header.minDensity = double(min(mRCImage.volume(:)));
  mRCImage.header.maxDensity = double(max(mRCImage.volume(:)));
  mRCImage.header.meanDensity = double(mean(mRCImage.volume(:)));

  mRCImage.type = 'MRC-2K';
  mRCImage.header.spaceGroup = 0;
  mRCImage.header.nSymmetryBytes = 0;
  mRCImage.header.extra = zeros(100,1);
  mRCImage.header.xOrigin = 0;
  mRCImage.header.yOrigin = 0;
  mRCImage.header.zOrigin = 0;
  mRCImage.header.map = 'MAP ';
  mRCImage.header.machineStamp = 0;
  mRCImage.header.densityRMS = std(double(mRCImage.volume(:)));
  
  mRCImage.flgVolume = 1;
  mRCImage.header.nBytesExtended = 0;
  mRCImage.header.nLabels = 0;

else
  if nargin < 2
    % Direct copy
    mRCImage = varargin{1};
  else
    % Copy an existing MRCImage (file and object) and give it a new filename
    destFilename = varargin{2};
    if destFilename(1) ~= '/'
      workingDir = cd;
      destFilename = [workingDir '/' destFilename];
    end
    srcFilename = varargin{1}.filename;
    [stat message] = copyfile(srcFilename,  destFilename);
    if ~ stat
      disp(message);
      error('Unable to copy file');
      return
    end
    mRCImage = varargin{1};

    % Reset the file descriptor
    mRCImage.fid = [];

    % Open the copied file in the same form as the source MRCImage
    mRCImage = open(mRCImage, destFilename, mRCImage.flgVolume);   
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: MRCImage.m,v $
%  Revision 1.13  2005/05/09 17:47:05  rickg
%  Comment updates
%
%  Revision 1.12  2004/07/20 23:14:12  rickg
%  Set statistics correctly for array argument constructors
%  Changed extra section to zeros.
%
%  Revision 1.11  2004/07/17 16:15:15  rickg
%  Added creation of int16, single and double volumes
%
%  Revision 1.10  2004/07/02 20:06:50  rickg
%  Help update
%
%  Revision 1.9  2004/07/01 23:34:16  rickg
%  Added new methods for constructing with headers
%  Updated help comments
%
%  Revision 1.8  2004/06/30 23:22:47  rickg
%  Help comment fixes
%
%  Revision 1.7  2004/04/28 04:59:18  rickg
%  Added constructor method for uint8 volume
%
%  Revision 1.6  2004/03/20 00:22:21  rickg
%  Added copy constructor that creates a new file (and modifies the associated
%  filename member)
%
%  Revision 1.5  2004/01/04 18:31:41  rickg
%  Comment change for flgLoad
%
%  Revision 1.4  2003/11/17 06:13:04  rickg
%  Added functionality for not loading volume
%
%  Revision 1.3  2003/11/13 20:06:20  rickg
%  Allows creation of a empty MRCImage structure from the specified header
%
%  Revision 1.2  2003/02/07 05:08:06  rickg
%  Help updates
%
%  Revision 1.1.1.1  2002/12/14 07:28:50  rickg
%  Initial Revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
