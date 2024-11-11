function [pdiff, pslope] = getshift(BigCPI)

[RangeGates Pulses ] = size(BigCPI);

for rg = 1:RangeGates,
    phase = unwrap(angle(BigCPI(rg,:)));

    y1 = [ (1:16)' ones(16,1) ] \ phase(1:16)';
    y2 = [ (17:32)' ones(16,1) ] \ phase(17:32)';
    y3 = [ (33:48)' ones(16,1) ] \ phase(33:48)';
    y4 = [ (49:64)' ones(16,1) ] \ phase(49:64)';

    c1c2diff(rg) = y1(2) - y2(2);
    c1c3diff(rg) = y1(2) - y3(2);
    c1c4diff(rg) = y1(2) - y4(2);

    slope(rg,:) = [ y1(1) y2(1) y3(1) y4(1) ];
    
end

pdiff = [mean(c1c2diff) mean(c1c3diff) mean(c1c4diff)];
pslope = mean(slope);


