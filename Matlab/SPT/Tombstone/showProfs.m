%showProfs      Show the profiles in a profs structure
%
%  showProfs(profs)
%
%  Status: under development
function showProfs(profs)

nComp = length(profs);
clf
for i = 1:nComp
  [nProfs nElem] = size(profs(i).Profile);
  subplot(nComp, 1, i)
  plot([1:nElem] .* (850/1024), profs(i).Profile');
  grid on
  xlabel('Mils')
  title(profs(i).Name);
end
