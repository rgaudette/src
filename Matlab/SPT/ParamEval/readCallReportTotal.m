%readCallReportTotal  Calculate the total calls froma a call report
%
%  callArray = readCallReportTotal(callRptFile, callArray, measParam)
%
%  callArray    A structure containg a description of the measurement
%               parameters and a five dimensional cell array of sparse matrices
%               named count indicating which pins and indictments were
%               present in the call report.  The index format for the count
%               cell array is: 
%                 {idxComp, idxZ, idxFOV, idxRes, idxIC}(idxPin).
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

function totalCallArray = ...
    readCallReportTotal(callReportFile, totalCallArray, measParam)

%%
if nargin < 2
  totalCallArray = [];
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
totalCallArray = parseCallReport(fid, totalCallArray, measParam);

fclose(fid);

%%
%% parseCallReport
%%
function totalCallArray = parseCallReport(fid, totalCallArray, measParam)

nJointsThisFile = 0;

if nargin < 2 | isempty(totalCallArray)
  totalCallArray.zHeight = measParam.zHeight;
  totalCallArray.FOVList = measParam.FOVList;
  totalCallArray.ResList = measParam.ResList;
  totalCallArray.ICList = measParam.ICList;
  totalCallArray.totalJoints = 0;
  totalCallArray.nCompJoints = [];
  
  %%
  %%  Two cell arrays to specify the index values of the compID and
  %%  indictment list
  %%
  totalCallArray.compID = {};
  totalCallArray.count = {};
end

%%
%%  Read in the header line and then the first data line, if the
%%  first characters are not Joint# then it is a header line
%%
line = fgetl(fid);
if line == -1
  return
end
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
  %% a duplicated component (not duplicate components are used for alignment
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
    %%  Check to see if the component exist in the call array, create an
    %%  empty one if it doesn't
    %%
    idxComp = getCompIndex(totalCallArray, compID);
  
    if idxComp == 0
      totalCallArray = addNewComp(totalCallArray, compID);
      idxComp = length(totalCallArray.compID);
    end
    totalCallArray.nCompJoints(idxComp) = totalCallArray.nCompJoints(idxComp) + 1;

    %%
    %%  If the component was rejected, increment the call count
    %%
    if strcmp('rejected ', decision)
      idxFOV = find(totalCallArray.FOVList == eval(FOV));
      idxRes = find(totalCallArray.ResList == eval(Res));
      idxIC = find(totalCallArray.ICList == eval(IC));
      idxPin = eval(pinID);

      totalCallArray = incrCount(totalCallArray, idxComp, idxZ, idxFOV, idxRes, ...
                                idxIC, idxPin);
    end
    nJointsThisFile = nJointsThisFile + 1;
  end
  line = fgetl(fid);
end
totalCallArray = makeCountsConsistent(totalCallArray);
totalCallArray.totalJoints = totalCallArray.totalJoints + nJointsThisFile;

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
%%  Find the index of the component in the totalCallArray or return 0 if the
%%  component does not exist.
%%
function idxComp = getCompIndex(totalCallArray, compName)
idxComp = 0;
nElem = length(totalCallArray.compID);
i = 1;
while i <= nElem
  if strcmp(totalCallArray.compID{i}, compName)
    idxComp = i;
    break;
  end
  i = i + 1;
end


%%
%%  Increment (and create if necessary) the sparse matrix entry corresponding
%%  to the appropriate pin  of the cell array element specified
%%  by the component, z height, FOV, Res and IC.
%%
function totalCallArray = incrCount(totalCallArray, idxComp, idxZ, idxFOV, ...
                                    idxRes, idxIC, idxPin);

[nComp nZ nFOV nRes nIC] = size(totalCallArray.count);

%%
%%  If an entry does not exist for the given parameter create a sparse to
%%  place into the cell array
%%
if idxComp > nComp | idxZ > nZ | idxFOV > nFOV | idxRes > nRes | idxIC > nIC
  totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC} = ...
      sparse(idxPin, 1, 1);
else
  %%
  %%  Check to see if the cell array entry is empty, if so insert the
  %%  approrpiate sparse array
  if isempty(totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC})
    totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC} = ...
        sparse(idxPin, 1, 1);
    
  else
    %%
    %%  Check to see that the sparse array has enough elements in each dimension
    %%  if not exapnd it
    %%
    [nPin junk] = size(totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, ...
                    idxIC});
    if idxPin > nPin 
      totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}(idxPin, 1) ...
          = 1;
    else
      totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}(idxPin, 1) ...
          = totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}...
          (idxPin, 1) + 1;
    end
  end
end

%%
%%  Make all entries in the count cell array sparse matrices and make sure
%%  they are all of the make size found for each component
%%
function totalCallArray = makeCountsConsistent(totalCallArray)
nFOV = length(totalCallArray.FOVList);
nRes = length(totalCallArray.ResList);
nIC = length(totalCallArray.ICList);
nZ = length(totalCallArray.zHeight);
nComp = length(totalCallArray.compID);

for idxComp = 1:nComp
  
  %%
  %%  Find the maximum number of pins for this component
  %%
  nPin = 0;

  for idxIC = 1:nIC
    for idxRes = 1:nRes
      for idxFOV = 1:nFOV
        for idxZ = 1:nZ

          [cPin junk] = size(totalCallArray.count{idxComp, idxZ, idxFOV, ...
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

          [cPin junk] = ...
              size(totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC});
          if cPin < nPin
            totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}...
                (nPin, 1) = 0;
          
          end
        end
      end
    end
  end
end

%%
%%
%%
function totalCallArray = addNewComp(totalCallArray, compID)
disp(['  ' compID])
totalCallArray.compID{end+1} = compID;
idxComp = length(totalCallArray.compID);
nFOV = length(totalCallArray.FOVList);
nRes = length(totalCallArray.ResList);
nIC = length(totalCallArray.ICList);
nZ = length(totalCallArray.zHeight);
totalCallArray.nCompJoints(end+1) = 0;

for idxIC = 1:nIC
  for idxRes = 1:nRes
    for idxFOV = 1:nFOV
      for idxZ = 1:nZ
        totalCallArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}=sparse(1,1,0);
      end
    end
  end
end
