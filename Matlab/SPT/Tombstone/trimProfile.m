%trimProfile    Remove leading and trailing zeros in the profile data
%
%  profOut = trimProfile(profIn)
%
%  Status: functional

function profOut = trimProfile(profIn)


[nProfs nSamples] = size(profIn);
for iProf = 1:nProfs
  idxNZ = find(profIn(iProf,:)  ~= 0);
  idxStart = idxNZ(1);
  idxStop = idxNZ(end);

  if ~exist('profOut', 'var')
    nTrim = idxStop - idxStart + 1;
    profOut = zeros(nProfs, nTrim);
  else
    if (idxStop - idxStart + 1) ~= nTrim
      fprintf('Profile %d has %d samples\n', ...
              iProf, idxStop - idxStart + 1);
      error(['Expected ' int2str(nTrim) ' samples']);
    end
  end

  profOut(iProf, :) = profIn(iProf,[idxStart:idxStop]);
end

