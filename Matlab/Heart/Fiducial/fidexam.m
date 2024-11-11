%FIDEXAM        Exam a fiducial estimate of a number of leads
%
%

function badleads = fidexam(Leads, Fiducial)
badleads = [];
PlotWidth = 50;
[nLeads nSamps] = size(Leads.data);
minLead = matmin(Leads.data);
maxLead = matmax(Leads.data);

for iLead = 1:nLeads,
    
    plot([1:nSamps] - Leads.TStim, Leads.data(iLead, :));
    axis([Fiducial(iLead)-PlotWidth Fiducial(iLead)+PlotWidth minLead maxLead]);
    grid on
    hold on

    h = plot([Fiducial(iLead) Fiducial(iLead)], [minLead maxLead], 'r');
    hold off
    xlabel('Time (ms)');
    ylabel('Amplitude (mV)');
    title(['Lead ' int2str(iLead)]);
    str = input('Enter b to mark a badlead', 's');
    if ~isempty(str)
        if str == 'b'
            badleads = [badleads iLead];
        end
    end
end

