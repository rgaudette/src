%ATYPLEAD       Identify atypical leads in plaque data.
%
%   idxAtyp = atyplead(Leads, idxActiv, idxRecov)
%
%   idxAtyp     The indices of the atypical leads.
%
%   Leads       The ECG sequence(s).  If ECGData is multiple leads, each row
%               should represent a different lead, each column a differenent
%               time instant.
%
%   idxActiv    The activation time index for each lead.
%
%   idxRecov    The recovery time index for each lead.
%
%
%   ATYPLEAD identifies atypical leads in a plaque data set.  The definition of
%   atypical leads here is an ST segement with a larger amplitude than the peak
%   value of the T wave.

function idxAtyp = atyplead(Leads, idxActiv, idxRecov)

[nLeads nSamples] = size(Leads);
idxAtyp = [];

%%
%%  Loop over each lead
%%
for idxLead = 1:nLeads,
    if max(Leads(idxLead, [idxActiv(idxLead)+1:idxRecov(idxLead)] )) > ...
       max(Leads(idxLead, [idxRecov(idxLead):nSamples] )),

       idxAtyp = [idxAtyp idxLead];
    end
end
