%ST_INT         Compute the ST segement integral.
%
%   STint = st_int(Leads, idxActiv, idxTPeak, Tsamp)
%
%   STint       The ST integral for each lead.
%
%   Leads       The ECG sequence(s).  If ECGData is multiple leads, each row
%               should represent a different lead, each column a differenent
%               time instant.
%
%   idxTPeak    The T wave peak time index for each lead.
%
%   Tsamp       [OPTIONAL] The sampling rate of the Leads (default: 1mS).

function STint = st_int(Leads, idxActiv, idxTPeak, Tsamp)

if nargin <4,
    Tsamp = 1E-3;
end

[nLeads nSamples] = size(Leads);

STint = zeros(nLeads,1);



%%
%%  Loop over each lead
%%
for idxLead = 1:nLeads,
    ST = Leads(idxLead, [idxActiv(idxLead):idxTPeak(idxLead)]);
    STint(idxLead) = sum(ST) * Tsamp;
end