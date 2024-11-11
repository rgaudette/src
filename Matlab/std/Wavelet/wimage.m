%WIMAGE         Draw a wavelet transform as a color image.
%
%   wimage(w, SaMap)
%

function Wimage = wimage(w, SaMap);

%%
%%  The size of the image is define by the number of scales in the WT
%%  by the number of samples in the finest scale.
%%
nr = length(SaMap);
nc = SaMap(1);
Wimage = zeros(nr, nc);

ScaleStart = 1;
for r = 1:length(SaMap),
    %%
    %%  Compute the last element at the current scale.
    %%
    ScaleStop = ScaleStart + SaMap(r) - 1;

    %%
    %%  Compute the number of times the elements of the current scale must be
    %%  repeated in order to fill out the current scale vector.
    %%
    nRepeat = floor(nc / SaMap(r));
    wrepeat = ones(nRepeat, 1) * w(ScaleStart:ScaleStop)';
    wrepeat = wrepeat(:)';
    
    %%
    %%  If the number of samples in the current scale will not evenly divide
    %%  into the number of sample at the finest scale we can jusr repeat the
    %%  the last element.
    %%
    lwr = length(wrepeat);
    tail = nc - lwr;
    if tail,
        Wimage(r,1:lwr) = wrepeat(:)';
        Wimage(r, lwr+1:nc) = ones(1,tail) * wrepeat(lwr);
    else
        Wimage(r,:) = wrepeat(:)';
    end
    
    ScaleStart = ScaleStart + SaMap(r);
end

