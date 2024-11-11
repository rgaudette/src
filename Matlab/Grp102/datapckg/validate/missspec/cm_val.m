Files = ['cm432a1v1'
 'cm432a2v1'
 'cm432b1v1'
 'cm432b2v1'
 'cm432c1v1'
 'cm432c2v1'
 'cm432d1v1'
 'cm432d2v1'
 'cm432e1v1'
 'cm432e2v1'
 'cm435a1v1'
 'cm435a2v1'
 'cm435b1v1'
 'cm435b2v1'
 'cm435c1v1'
 'cm435c2v1'
 'cm435d1v1'
 'cm435d2v1'
 'cm435e1v1'
 'cm435e2v1'
 'cm438a1v1'
 'cm438a2v1'
 'cm438b1v1'
 'cm438b2v1'
 'cm438c1v1'
 'cm438c2v1'
 'cm438d1v1'
 'cm438d2v1'
 'cm438e1v1'
 'cm438e2v1'
 'cm485a1v1'
 'cm485a2v1'
 'cm485b1v1'
 'cm485b2v1'
 'cm485c1v1'
 'cm485c2v1'
 'cm485d1v1'
 'cm485d2v1'
 'cm485e1v1'
 'cm485e2v1'];

[nFiles nchar] = size(Files);
C = 299792458;
m2nmi = 5.39956803e-4;
for idx = 1:nFiles

    load(Files(idx,:))

    %%
    %%    Plot out the response closest to 200 degrees for channel 7.
    %%
    clf
    [offset idxClosest] = min(abs(azxmit - 200));
    signal = eval(['cpi' int2str(idxClosest) '(:,7)']);
    Range = [trecord:trecord+wrecord-1] * 1e-6 * C / 2 * m2nmi;
    plot(Range, db(v2p(signal)));
    axis([min(Range) max(Range) 30 120])
    grid
    xlabel('Range (NMi)')
    ylabel('Amplitude (dB)')

    title([Files(idx,:) ':  ' num2str(fxmit(idxClosest)/1e6) 'MHz, ' ...
        num2str(azxmit(idxClosest)) ' degrees, Channel 7'])
    tag
    print
end