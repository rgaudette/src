% Compare differnt tube thicknesses for 

% Load in the data if is is not already loaded

if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

ax6Model = ImodModel('ax6.mod');
ax6points = getPoints(ax6Model, 1, 1)';
ax6DyneinPos = getPoints(ax6Model, 1, 2)';

%nmPerSample = 1.07;
%dyneinHead = [13 11] ./ nmPerSample;

dyneinHead = 19; 
[tb3 coords3 planeLocs3] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 3], 'nearest');
[tb5 coords5 planeLocs5] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 5], 'nearest');
[tb7 coords7 planeLocs7] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 7], 'nearest');
[tb9 coords9 planeLocs9] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 9], 'nearest');
[tb11 coords11 planeLocs11] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 11], 'nearest');
[tb13 coords13 planeLocs13] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 13], 'nearest');
[tb15 coords15 planeLocs15] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 15], 'nearest');
[tb17 coords17 planeLocs17] = interpTube(ax6, ax6points, [1 1 1], [dyneinHead 17], 'nearest');


sumtb3 = squeeze(sum(sum(tb3,1),2));
nsumtb3 = sumtb3 - mean(sumtb3);

sumtb5 = squeeze(sum(sum(tb5,1),2));
nsumtb5 = sumtb5 - mean(sumtb5);

sumtb7 = squeeze(sum(sum(tb7,1),2));
nsumtb7 = sumtb7 - mean(sumtb7);

sumtb9 = squeeze(sum(sum(tb9,1),2));
nsumtb9 = sumtb9 - mean(sumtb9);

sumtb11 = squeeze(sum(sum(tb11,1),2));
nsumtb11 = sumtb11 - mean(sumtb11);

sumtb13 = squeeze(sum(sum(tb13,1),2));
nsumtb13 = sumtb13 - mean(sumtb13);

sumtb15 = squeeze(sum(sum(tb15,1),2));
nsumtb15 = sumtb15 - mean(sumtb15);

sumtb17 = squeeze(sum(sum(tb17,1),2));
nsumtb17 = sumtb17 - mean(sumtb17);

F = [0:1868] ./ 1869;

figure(1)

clf
plot(F, abs(fft(nsumtb3)), 'b');
hold on

plot(F, abs(fft(nsumtb5)), 'r.');
plot(F, abs(fft(nsumtb7)), 'g:');
plot(F, abs(fft(nsumtb9)), 'm-.');
plot(F, abs(fft(nsumtb11)), 'k--');
plot(F, abs(fft(nsumtb13)), 'c');
plot(F, abs(fft(nsumtb15)), 'r-.');
plot(F, abs(fft(nsumtb17)), 'g--');
