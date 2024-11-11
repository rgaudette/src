%TACTIV         Estimate the activation time of a number of ECG lead.
%
%    [idxActiv] = tactiv(Leads)
%
%    idxactiv    The estimated activation time index for each lead.
%
%    Leads       The ECG sequence(s).  If ECGData is multiple leads, each row
%                should represent a different lead, each column a differenent
%                time instant.
%
%        TACTIV estimates the activation time using the simple method finding
%    the largest negative value of the first difference function.

function [idxActiv] = tactiv(Leads)

%%
%%  Compute first difference function of each lead
%%
Diff = diff(Leads');

%%
%%  Find index of largest negative value
%%
[dv idxActiv] = min(Diff);
idxActiv = idxActiv';

