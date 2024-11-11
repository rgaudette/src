%TDETTEST       Test the t-wave detectors.
%
%    bad = tdettest(Leads, idxRecov, idxTWave, vecTest)
function bad = tdettest(Leads, idxRecov, idxTWave, vecTest)

bad = [];
[nLeads nSamples] = size(Leads);

if nargin < 4,
    vecTest = 1:nLeads;
end

for iLead = vecTest,

    plot(Leads(iLead,:))
    Axis = axis;
    hold on
    plot([idxRecov(iLead) idxRecov(iLead)], [Axis(3) Axis(4)], 'r');
    plot([idxTWave(iLead) idxTWave(iLead)], [Axis(3) Axis(4)], 'b');
    xlabel('Time (uS)')
    title(['Lead #' int2str(iLead)]);
    hold off

    flgBad = input('Enter 1 to add to bad list: ');

    if flgBad,
        bad = [bad iLead];
    end
    
end

