%stalkinit_mce      Create the initial motive list and particle model from a
%               stalk model
%
%   stalkinit_mce(fnParameters)
%
%   fnParameters The name of the parameter file.  This should be MATLAB
%               evaluatable (i.e. each line of the file will be eval'd).
%               The parameters read from file are:
%
%     fnStalkModel = 'stalk.mod';
%     iRef = 1;
%     fnHead = 'head.mod';
%     fnCentroid = 'centroid.mod';
%     fnInitMotiveList = 'stalk_MOTL_1.em';
%     debugLevel = 2;
%
%   stalkinit_mce creates an initial motive list and an initial particle model
%   from a model identify the stalks (ATPsynthase) in a tomogram.
%
%   See also: stalk2MOTL
%
%   Bugs: none known       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:20:16 $
%
%  $Revision: 1.6 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function retval = stalkinit_mce(varargin)

global PRINT_ID

st = clock;
% Default values
fnCentroid = 'centroid.mod';

% Parse the parameter file
filename = varargin{1};
[fid msg] = fopen(filename, 'r');
if fid == -1
  error('% : %s\n', filename, msg);
end
parseVariableFile
if PRINT_ID
    fprintf('$Id: stalkinit_mce.m,v 1.6 2005/08/15 23:20:16 rickg Exp $\n');
end

% Print out the values of the parameter file
if debugLevel > 1
  fnStalkModel
  iRef
  fnHead
  fnCentroid
  fnInitMotiveList
end

stalk2MOTL(fnStalkModel, iRef, fnHead, fnCentroid, fnInitMotiveList);

if debugLevel > 0
  fprintf('Total execution time : %f seconds\n', etime(clock, st));
end

retval = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: stalkinit_mce.m,v $
%  Revision 1.6  2005/08/15 23:20:16  rickg
%  Typo fix
%
%  Revision 1.5  2005/08/15 23:02:52  rickg
%  Added global print ID
%
%  Revision 1.4  2005/04/07 22:22:50  rickg
%  preserve on install
%  mce renaming
%
%  Revision 1.3  2005/01/14 18:25:04  rickg
%  Switch to parseVariableFile
%
%  Revision 1.2  2005/01/08 00:01:01  rickg
%  Added centroid calculation
%  Handle empty template file lines
%
%  Revision 1.1  2004/12/01 18:18:10  rickg
%  *** empty log message ***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
