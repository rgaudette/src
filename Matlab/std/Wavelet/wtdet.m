%WTDET          Wavelet Transform Detector
%
%   idxDet = wtdet(w, alpha)

function detmat = wtdet(w, map, alpha)

nscales = length(map);

detmat = zeros(nscales, 2*map(1));

%%
%%  At each scale find the indicies that are above the detection thrreshold,
%%  zero order hold the detection sequence to align scales in time.

for i = 1:nscales,
    x = wcunpack(w, map, i);
    det = x > alpha;
    det = det(:)';
    det = ones(2*map(1)/map(i),1) * det;
    det = det(:)';
    detmat(i,:) = det;
end

        
