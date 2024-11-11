%volRotate_mce Rotate a volume
%
%   result = template(parm, Optional)
%
%   result      Output description
%
%   parm        Input description [units: MKS]
%
%   Optional    OPTIONAL: This parameter is optional (default: value)
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:02:52 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function retVal = volRotate_mce(varargin)

global PRINT_ID

fprintf('\n\n');

% Default values
origin = [];
method = 'linear';
extrapValue = [];

retVal = 0;

% Parse the command line
flgEulerAngles = 0;
flgSlicerAngles = 0;
inputFile = '';
outputFile = '';

nArgs = length(varargin);
iArg = 1;
while iArg <= nArgs
  switch varargin{iArg}

    case {'-e','--euler'}
      iArg = iArg + 1;
      try
        [str1 str2 str3] = parseTriple(varargin{iArg});
        phi = eval(str1);
        theta = eval(str2);
        psi = eval(str3);
      catch
        disp('Incorrect parmeter format for euler angle argument');
        disp('Use --euler phi,theta,psi')
        retVal = 1;
        error(lasterr);
      end
      flgEulerAngles = 1;

    case {'-i','--input'}
      iArg = iArg + 1;
      inputFile = varargin{iArg};

    case {'-o','--output'}
      iArg = iArg + 1;
      outputFile = varargin{iArg};

    case {'-s','--slicer'}
      iArg = iArg + 1;
      try
        [str1 str2 str3] = parseTriple(varargin{iArg});
        rotX = eval(str1);
        rotY = eval(str2);
        rotZ = eval(str3);
      catch
        disp('Incorrect parmeter format for slicer angle argument');
        disp('Use --slicer rotX,rotY,rotZ')
        retVal = 1;
        error(lasterr);
      end
      flgSlicerAngles = 1;

    otherwise
      % Assume that it is either an input or ouput file
      if isempty(inputFile)
        inputFile = varargin{iArg};
      elseif isempty(outputFile)
        outputFile = varargin{iArg};
      else
        warning('Extra argument %s\n', varargin{iArg});
      end

  end
  iArg = iArg + 1;
end

if isempty(inputFile)
  retVal = 1;
  error('The input file has not been specified');
end
  
if isempty(outputFile)
  retVal = 1;
  error('The output file has not been specified');
end


if flgSlicerAngles & flgEulerAngles
  retVal = 1;
  error('Only one of Euler or slicer angles must be specified\n');
end

if ~ (flgSlicerAngles | flgEulerAngles)
  retVal = 1;
  error('At least one of Euler or slicer angles must be specified\n');
end

if flgEulerAngles
  euler = [phi theta psi];
else
  euler = zyx2Euler([rotX rotY rotZ] * pi / 180);
end

%  Rotate the volume by the specified angle
mrcVolume = MRCImage(inputFile);
volume = getVolume(mrcVolume, [], [], []);
volume = volumeRotate(volume, euler, origin,  method, extrapValue);
save(MRCImage(volume), outputFile);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [arg1 arg2 arg3] = parseTriple(str)

[arg1 rem] = strtok(str, ',');
if isempty(arg1)
  error('Missing first argument');
end

[arg2 rem] = strtok(rem, ',');
if isempty(arg2)
  error('Missing second argument');
end

[arg3 rem] = strtok(rem, ',');
if isempty(arg3)
  error('Missing third argument');
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volRotate_mce.m,v $
%  Revision 1.3  2005/08/15 23:02:52  rickg
%  Added global print ID
%
%  Revision 1.2  2005/04/07 22:22:50  rickg
%  preserve on install
%  mce renaming
%
%  Revision 1.1  2005/01/12 00:01:02  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
