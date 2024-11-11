%loadVerificationRegionUsage

function [useTop useBottom] = loadVerificationRegionUsage

% Open the file
fid = fopen('verificationRegionUsage.txt')
nLine = 1
while true
  line = fgetl(fid);
  if ~ischar(line), break, end
  
  % Remove the white space from the string
  line = strrep(line, ' ', '');
  useTop(nLine, :) = (line == 'T') | (line == '+');
  useBottom(nLine, :) = (line == 'B') | (line == '+');
  nLine = nLine + 1;
end