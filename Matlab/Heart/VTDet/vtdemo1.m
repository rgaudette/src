%VTDEMO1        Plot the detection status of a beat sequence

function vtdemo1(cseq, test)

%%
%%  Generate the template structure
%%
mb = meanbeat(mkegstrct(cseq));

DetStruct = cwavtdet(mkegstrct(test), mb);

%%
%%
%%
clf

subplot(5,1,1);
plot(cseq);
axis([0 length(cseq) -70 70])

subplot(5,1,3);
plot(test);
axis([0 length(test) -70 70])

subplot(5,1,4);
plot(DetStruct.BadBeatDet)
axis([0 length(test) -.25  1.25])

subplot(5,1,5)
plot(DetStruct.VTDet)
axis([0 length(test) -.25  1.25])
