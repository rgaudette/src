%QRST_INT       Compute the QRST segement integral.
%
%   QRSTint = qrst_int(Leads, Start, Stop, Tsamp)
%
%   QRSTint     The QRST integral for each lead.
%
%   Leads       The ECG sequence(s).  If ECGData is multiple leads, each row
%               should represent a different lead, each column a differenent
%               time instant.
%
%   Start       The initial integration starting index for all of the leads.
%
%   Tsamp       [OPTIONAL] The sampling rate of the Leads (default: 1mS).

function  QRSTint = qrst_int(Leads, Start, Stop, Tsamp)

if nargin < 4
    Tsamp = 1E-3;
end

QRSTint = sum(Leads(:,[Start:Stop])');

QRSTint = QRSTint * Tsamp;