%TRECOV         Find the recovery time of single beat of an ECG.
%
%   [Idx Slope] = trecov(ECGData)
%
%   Idx         The sample index(s) corresponding to the recovery time.
%
%   Slope       The estimated slope at the sample index(s).
%
%   ECGData     The ECG sequence(s).  If ECGData is multiple leads, each row
%               should represent a different lead, each column a differenent
%               time instant.
%
%   TRECOV returns the index of the first local maxima in the first difference
%   function working back from the peak of the t-wave.  The peak of the t-wave
%   is identified by first finding the largest negative first differnce
%   (presumably the activation time) from there finding the maximum value from
%   that point on.

function [Idx Slope] = trecov(ECGData)

%%
%%  Size of data
%%
[nLeads nSamples] = size(ECGData);

%%
%%  Compute first difference of each lead
%%
Diff = diff(ECGData');

%%
%%  Find activation indices
%%
idxAct = min(Diff);

%%
%%  Find the maximum amplitude for each lead from acivation index on, this
%%  should be the peak of the t-wave.
%%
