%ERICROT        Rotate Eric's system matrices

function Aout = ericrot(Ain, nX , nZ)

[nSDpairs nElem] = size(Ain);
Aout = zeros(nSDpairs, nElem);

for iSD = 1:nSDpairs
    temp = fliplr(reshape(Ain(iSD, :), nZ, nX)');
    Aout(iSD, :) = temp(:)';
end
