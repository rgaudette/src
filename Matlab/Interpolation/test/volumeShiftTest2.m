function  volumeShiftTest2

% Create a reference volume with the coordinate axis marked
ref = zeros(64,64,64);
center = floor(size(ref) / 2 ) + 1;
ly = 16;
ref([center(1):center(1)+ly-1], center(2), center(3)) = 1;
lx = 24;
ref(center(1), [center(2):center(2)+lx-1], center(3)) = 1;
lz = 32;
ref(center(1), center(2), [center(3):center(3)+lz-1]) = 1;
figure(1)
tom_dspcub(ref);


shift = [2 -3 4];
tshift = tom_shift(ref, shift);

figure(2)
tom_dspcub(tshift);

[xcf peakCCC shiftEst] = maskedCCC3(ref, tshift, 10);
peakCCC
shiftEst