function  volumeRotateTest2

% Create a reference volume with the coordinate axis marked
ref = zeros(64,64,64);
center = floor(size(ref) / 2 ) + 1
lx = 16;
ref([center(1):center(1)+lx-1], center(2), center(3)) = 1;
ly = 24;
ref(center(1), [center(2):center(2)+ly-1], center(3)) = 1;
lz = 32;
ref(center(1), center(2), [center(3):center(3)+lz-1]) = 1;

figure(1)
tom_dspcub(ref);

eulerAngles = [2 3 4] * pi / 180;
method = 'linear';
rot = volumeRotate(ref, eulerAngles, [], method);

figure(2)
tom_dspcub(rot);
invrot = volumeRotateInv(rot, -1 * eulerAngles, [], method);

figure(3)
tom_dspcub(invrot);

figure(4)
rDiff = ref - invrot;
tom_dspcub(rDiff)
max(abs(rDiff(:)))

figure(5)
imagesc(ref(:,:,center(3)))

figure(6)
imagesc(rot(:,:,center(3)))

figure(7)
imagesc(invrot(:,:,center(3)))
colorbar('vert');
[xcf peakCCC shift] = maskedCCC3(ref, invrot, 15);
peakCCC
shift
