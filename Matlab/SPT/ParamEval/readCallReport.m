%readCallReport Read in a res file call report from param. eval. study
%
%  callArray = readCallReport(callRptFile, callArray, measParam)
%
%  callArray    A structure containg a description of the measurement
%               parameters and a five dimensional cell array of sparse matrices
%               named count indicating which pins and indictments were
%               present in the call report.  The index format for the count
%               cell array is: 
%                 {idxComp, idxZ, idxFOV, idxRes, idxIC}(idxPin, idxIndict).
%               The other fields are
%                 zHeight
%                 FOVList
%                 ResList
%                 ICList
%                 totalJoints
%                 nCompJoints
%                 compID
%                 indictList
%
%  callRptFile  The name of the text file containing the calls.  Typically
%               generated from callrpt.exe.
%
%  measParam    A data structure containing the fields: zHeight which
%               specifies the values of the z offsets for each z index,
%               FOVList, ResList and ICList  which specify the FOVs,
%               resolutions, and integrations used and how to index them
%               in the callArray.
%
%  If a non-empty callArray is passed in as an input argument then the
%  approriate 
function callArray = readCallReport(callReportFile, callArray, measParam)

%%
if nargin < 2
  callArray = [];
end

%%
%% Open the specified file
%%
[fid msg] = fopen(callReportFile, 'r');
if fid == -1
  error(msg);
end

%%
%%  Parse the call report
%%
callArray = parseCallReport(fid, callArray, measParam);

fclose(fid);

%%
%% parseCallReport
%%
function callArray = parseCallReport(fid, callArray, measParam)

nJointsThisFile = 0;

if nargin < 2 | isempty(callArray)
  callArray.zHeight = measParam.zHeight;
  callArray.FOVList = measParam.FOVList;
  callArray.ResList = measParam.ResList;
  callArray.ICList = measParam.ICList;
  callArray.totalJoints = 0;
  callArray.nCompJoints= [];
  
  %%
  %%  Two cell arrays to specify the index values of the compID and
  %%  indictment list
  %%
  callArray.compID = {};
  callArray.indictList = {};
  callArray.count = {};
end

%%
%%  Read in the header line and then the first data line, if the
%%  first characters are not Joint# then it is a header line
%%
line = fgetl(fid);
if line(1:6) == 'Joint#'
  line = fgetl(fid);
end

while line ~= -1
  %%
  %%  Parse the line by splitting up comma-space delimited sections
  %%
  [jointNum restOfLine] = strtok(line, ',');
  [longCompID restOfLine] = strtok(restOfLine(3:end), ',');

  %%
  %% We need at least 4 underscores in the long component ID to consider this
  %% a duplicated component (non duplicate components are used for alignment
  %% only).
  %%
  if length(findstr(longCompID, '_')) > 3
    [pinID restOfLine] = strtok(restOfLine(3:end), ',');
    [layer restOfLine] = strtok(restOfLine(3:end), ',');  
    [family restOfLine] = strtok(restOfLine(3:end), ',');  
    [decision restOfLine] = strtok(restOfLine(3:end), ',');  
    
    %%
    %%  Parse the component ID
    %%
    [compID, FOV, Res, IC, idxZ] = parseLongCompID(longCompID);

    %%
    %%  Check to see if the component exists in the call array, append an
    %%  empty component if it doesn't
    %%
    idxComp = getCompIndex(callArray, compID);
  
    if idxComp == 0
      callArray = addNewComp(callArray, compID);
      idxComp = length(callArray.compID);
    end
    callArray.nCompJoints(idxComp) = callArray.nCompJoints(idxComp) + 1;

    %%
    %%  If the component was rejected, add the defects to the callArray
    %%
    if strcmp('rejected ', decision)
      idxFOV = find(callArray.FOVList == eval(FOV));
      idxRes = find(callArray.ResList == eval(Res));
      idxIC = find(callArray.ICList == eval(IC));
      idxPin = eval(pinID);

    
      %%
      %%  Loop over the calls incrementing the counter for each call a flag
      %%  needs to be set for shorts since it can be called multiple times
      %%
      flgShort = 0;
      while ~isempty(restOfLine)
        [indict restOfLine] = strtok(restOfLine(3:end), ',');
        %%
        %%  Skip any diags
        %%
        if isempty(findstr(indict, 'Diag'))
          if ~flgShort
            idxIndict = getIndictIndex(callArray, indict);
            if idxIndict == 0
              callArray.indictList{end+1} = indict;
              idxIndict = length(callArray.indictList);
            end
            callArray = incrCount(callArray, idxComp, idxZ, idxFOV, idxRes, ...
                                  idxIC, idxPin, idxIndict);
            if findstr(indict, 'Short')
              flgShort = 1;
            end
          end
        end
      end
    end
    nJointsThisFile = nJointsThisFile + 1;
  end
  line = fgetl(fid);
end
callArray = makeCountsConsistent(callArray);
callArray.totalJoints = callArray.totalJoints + nJointsThisFile;

%%
%%  parseLongCompID
%%
function [compID, FOV, Res, IC, idxZ] = parseLongCompID(longCompID)
[compID restOfString] = strtok(longCompID, '_');
[FOV restOfString] = strtok(restOfString(2:end), '_');
%%
%%  Check to see if the current FOV label candidate is actually a number
%%  by examining the ASCII values of the string
%%
if any(abs(FOV) < 48) | any(abs(FOV) > 57)
  compID = [compID '_' FOV];
  [FOV restOfString] = strtok(restOfString(2:end), '_');
end
[Res restOfString] = strtok(restOfString(2:end), '_');
[IC restOfString] = strtok(restOfString(2:end), '_');
idxZ = eval(restOfString(3:end)) + 1;

%%
%%  getCompIndex
%%
%%  Find the index of the component in the callArray or return 0 if the
%%  component does not exist.
%%
function idxComp = getCompIndex(callArray, compName)
idxComp = 0;
nElem = length(callArray.compID);
i = 1;
while i <= nElem
  if strcmp(callArray.compID{i}, compName)
    idxComp = i;
    break;
  end
  i = i + 1;
end

%%
%%
%%
function idxIndict = getIndictIndex(callArray, indict)
idxIndict = 0;
nElem = length(callArray.indictList);
i = 1;
while i <= nElem
  if strcmp(callArray.indictList{i}, indict)
    idxIndict = i;
    break;
  end
  i = i + 1;
end

%%
%%  Increment (and create if necessary) the sparse matrix entry corresponding
%%  to the appropriate pin and indictment of the cell array element specified
%%  by the component, z height, FOV, Res and IC.
%%
function callArray = incrCount(callArray, idxComp, idxZ, idxFOV, idxRes, ...
                               idxIC,idxPin, idxIndict);

[nComp nZ nFOV nRes nIC] = size(callArray.count);

%%
%%  If an entry does not exist for the given parameter create a sparse to
%%  place into the cell array
%%
if idxComp > nComp | idxZ > nZ | idxFOV > nFOV | idxRes > nRes | idxIC > nIC
  callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC} = ...
      sparse(idxPin, idxIndict, 1);
else
  %%
  %%  Check to see if the cell array entry is empty, if so insert the
  %%  approrpiate sparse array
  if isempty(callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC})
    callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC} = ...
        sparse(idxPin, idxIndict, 1);
    
  else
    %%
    %%  Check to see that the sparse array has enough elements in each dimension
    %%  if not exapnd it
    %%
    [nPin nIndict] = size(callArray.count{idxComp, idxZ, idxFOV, idxRes, ...
                    idxIC});
    if idxPin > nPin | idxIndict > nIndict
      callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC} ...
          (idxPin, idxIndict) = 1;
    else
      callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC} ...
          (idxPin, idxIndict) ...
          = callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}...
          (idxPin, idxIndict) + 1;
    end
  end
end

%%
%%  Make all entries in the count cell array sparse matrices and make sure
%%  they are all of the make size found for each component
%%
function callArray = makeCountsConsistent(callArray)
nFOV = length(callArray.FOVList);
nRes = length(callArray.ResList);
nIC = length(callArray.ICList);
nZ = length(callArray.zHeight);
nComp = length(callArray.compID);
nIndict = length(callArray.indictList);

for idxComp = 1:nComp
  
  %%
  %%  Find the maximum number of pins for this component
  %%
  nPin = 0;

  for idxIC = 1:nIC
    for idxRes = 1:nRes
      for idxFOV = 1:nFOV
        for idxZ = 1:nZ

          [cPin cIndict] = size(callArray.count{idxComp, idxZ, idxFOV, ...
                    idxRes, idxIC});
          if cPin > nPin
            nPin = cPin;
          end

        end
      end
    end
  end

  %%
  %%  Make all of the sparse arrays for the component the same size
  %%
  for idxIC = 1:nIC
    for idxRes = 1:nRes
      for idxFOV = 1:nFOV
        for idxZ = 1:nZ

          [cPin cIndict] = ...
              size(callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC});
          if cPin < nPin | cIndict < nIndict
            callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}(nPin, ...
                                                  nIndict) = 0;
          
          end
        end
      end
    end
  end
end

%%
%%
%%
function callArray = addNewComp(callArray, compID)
disp(['  ' compID])
callArray.compID{end+1} = compID;
idxComp = length(callArray.compID);
nFOV = length(callArray.FOVList);
nRes = length(callArray.ResList);
nIC = length(callArray.ICList);
nZ = length(callArray.zHeight);
callArray.nCompJoints(end+1) = 0;

for idxIC = 1:nIC
  for idxRes = 1:nRes
    for idxFOV = 1:nFOV
      for idxZ = 1:nZ
        callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}=sparse(1,1,0);
      end
    end
  end
end
