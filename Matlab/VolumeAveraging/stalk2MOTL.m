%stalk2MOTL     Head, centroid and initial motive list from a stalk model
%
%   stalk2MOTL(fnStalkModel, iRef, fnHeadModel, fnCentroidModel, ...
%              fnInitMotiveList)
%
%   fnStalkModel  The file name of the Imod stalk model
%
%   iRef        The index of the reference particle or 0 to align the
%               stalks with the Z axis.
%
%   fnHeadModel The file name of the Imod head model to create.
%
%   fnCentroidModel   The file name of the Imod centroid model to create.
%
%   fnInitMotiveList  The file name of the initial motive list to create.
%
%   stalk2MOTL create an initial motive list, head, and centroid Imod
%   models from a Imod model of the ATP synthase stalks.  Each stalk should
%   be modeled as a separate contour with the head being the first point
%   and the base of the stalk being the second.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:37 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stalk2MOTL(fnStalkModel, iRef, fnHeadModel, fnCentroidModel, ...
  fnInitMotiveList)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: stalk2MOTL.m,v 1.4 2005/08/15 23:17:37 rickg Exp $\n');
end

% Load in the stalk model
imodStalk= ImodModel(fnStalkModel);

% parse the stalk model
[imodHead imodCentroid initMotiveList] = parseStalkModel(imodStalk, iRef);

% Write out the head model
imodHead = write(imodHead, fnHeadModel);

% Write out the centroid model
imodCentroid = write(imodCentroid, fnCentroidModel);

% Write out the initial motive list
writeEM(MRCImage(initMotiveList), fnInitMotiveList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: stalk2MOTL.m,v $
%  Revision 1.4  2005/08/15 23:17:37  rickg
%  Type fix
%
%  Revision 1.3  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.2  2005/01/07 23:57:21  rickg
%  Added centroid calculation and help text
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
