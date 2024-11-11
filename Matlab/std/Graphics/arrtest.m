%ARRTEST        Arrows(2,3) speed test.
z = sqrt(peaks(23));
set(gca, 'drawmode', 'fast');
set(gcf, 'BackingStore', 'off');
st = clock;
for i = 1:10
    clf
    h = arrows2(z);
%   set(h, 'EdgeColor', 'none');
    drawnow;
end
etime(clock,st)