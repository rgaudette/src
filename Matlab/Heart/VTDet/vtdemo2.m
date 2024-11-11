%VTDEM02        Plot the detection status of a beat sequence

function vtdem02(train, test)

%%
%%  Generate the template structure
%%
%mb = meanbeat(mkegstrct(train));
testdata = [train; test];

DetStruct = wtvtdet(mkegstrct(testdata), mkegstrct(train));

%%
%% 
%%
clf
FSamp = 250;
t = [0:(length(testdata)-1)] ./ FSamp;

subplot(3,1,1);
plot(t, testdata);
axis([0 max(t) -70 70])
title('Original Electrogram Sequence')
ylabel('Amplitude')

subplot(3,1,2);
tp = t(1:length(DetStruct.BadBeatDet));
plot(tp, DetStruct.BadBeatDet)
axis([0 max(t) -.25  1.25])
title('Non-NSR Beat Detections');
ylabel('Detector State')

subplot(3,1,3)
tp = t(1:length(DetStruct.VTDet));
plot(tp, DetStruct.VTDet)
axis([0 max(t) -.25  1.25])
title('VT Beat Detections')
xlabel('time (Seconds)')
ylabel('Detector State')
