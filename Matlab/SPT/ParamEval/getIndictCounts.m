%getIndictCounts    Returns the number of indictments in a callArray
%                   given the indictment type and component ID.
%
% calls = getIndictCounts(callArray, indictment, compID)
%
function calls = getIndictCounts(callArray, indictment, compID)

%%
%% Get the indictment index
%%
idxIndict = findCellArrayStr(callArray.indictList, indictment);
if idxIndict == 0
  warning(['No indictment of type: ' indictment ' found']);
  calls = [];
  return
end
idxComp = findCellArrayStr(callArray.compID, compID);
if idxComp == 0
  warning(['Component: ' compID ' not found']);
  calls = [];
  return
end

nFOV = length(callArray.FOVList);
nRes = length(callArray.ResList);
nIC = length(callArray.ICList);
nZ = length(callArray.zHeight);

calls = zeros(nZ, nFOV, nRes, nIC);

for idxIC = 1:nIC
  for idxRes = 1:nRes
    for idxFOV = 1:nFOV
      for idxZ = 1:nZ
        if ~isempty(callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC})
          calls(idxZ, idxFOV, idxRes, idxIC) = ...
              sum(callArray.count{idxComp, idxZ, idxFOV, idxRes, idxIC}(:, ...
                                                  idxIndict));
        end
      end
    end
  end
end

  
