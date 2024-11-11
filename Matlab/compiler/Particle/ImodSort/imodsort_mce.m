%imodsort_mce       Sort the points in an IMOD model
%
%   sort -s idxStart [-o idxObject -c idxContour] -v inmodel outmodel
%
%
%   Sort the points in a IMOD model
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
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodsort_mce(varargin)

global PRINT_ID

if nargin < 4
  usage
  return
end

% Parse the input arguments
[idxStart idxObject idxContour objType flgVerbose inmodel outmodel] ...
  = parseArgs(varargin);

% Open the input model
if flgVerbose
  fprintf('Reading model %s\n', inmodel);
end
imodIn = ImodModel(inmodel, flgVerbose);

% Sort the specified contour
if flgVerbose
  fprintf('Sorting model\n');
end

imodOut = sortPoints(imodIn, idxObject, idxContour, idxStart);

if ~ isempty(objType)
  if flgVerbose
    fprintf('Changing object type to %s\n', objType);
  end
  imodOut = setObjectType(imodOut, idxObject, objType);
end

% Save the output model
if flgVerbose
  fprintf('Writing model %s\n', outmodel);
end
write(imodOut, outmodel, flgVerbose);


% Usage description
function usage
fprintf('imodsort -s idxStart [-o idxObject -c idxContour] [-v] [-t type] inmodel outmodel\n\n');
fprintf('\tidxStart\tThe index of the contour point start sorting from.\n\n');
fprintf('\tidxObject\tThe index of the object and contour to sort, the default.\n');
fprintf('\tidxContour\tis the first object and first contour.\n\n');
fprintf('\ttype\tChanges the object type being sorted (closed, open, scattered)\n\n');
fprintf('\tinmodel\t\tThe model containing the points to sort.\n\n');
fprintf('\toutmodel\tThe output model containing the sorted points.\n\n');


function [idxStart, idxObject, idxContour, objType, flgVerbose, inmodel, outmodel] = parseArgs(args)
idxObject = 1;
idxContour = 1;
inmodel = '';
outmodel = '';
flgVerbose = 0;
objType = '';
iarg = 1;
while iarg <= length(args)
  if strncmp('-', args{iarg}, 1)
    option = args{iarg};
    switch option
      case '-s'
        iarg = iarg+1;
        idxStart = eval(args{iarg});
        
      case '-o'
        iarg = iarg+1;
        idxObject = eval(args{iarg});
        
      case '-c'
        iarg = iarg+1;
        idxContour = eval(args{iarg});

     case '-t'
        iarg = iarg+1;
        objType = args{iarg};

      case '-v'
        flgVerbose = 1;
        
    end
        
  else
    if isempty(inmodel)
      inmodel = args{iarg};
    else
      outmodel = args{iarg};
    end
  end
  iarg = iarg + 1;
end

if isempty(inmodel)
  usage
  error('inmodel undefined');
end

if isempty(outmodel)
  usage
  error('outmodel undefined');
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: imodsort_mce.m,v $
%  Revision 1.4  2005/08/15 23:02:52  rickg
%  Added global print ID
%
%  Revision 1.3  2005/04/07 22:22:50  rickg
%  preserve on install
%  mce renaming
%
%  Revision 1.2  2005/02/25 23:27:49  rickg
%  Preserve object type
%  Allow for change of object type
%
%  Revision 1.1  2004/10/05 17:18:27  rickg
%  Initial revision
%
%  Revision 1.2  2004/10/01 23:38:57  rickg
%  True initial revision
%
%  Revision 1.1  2004/09/27 23:51:11  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
