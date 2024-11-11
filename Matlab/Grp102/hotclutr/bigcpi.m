%BIGCPI         Combine four RSTER CPIs to form a large Coherent Processing
%               Interval for a single channel.
%
%    [BigCPI nPulses] = bigcpi(wrecord, channel, cpi1, cpi2, cpi3, cpi4);
%
%    BigCPI     Data matrix of large CPI (wrecord x nPulses).
%
%    nPulses    The number of pulses for the large CPI.
%
%    wrecord    The width of the record window [samples].
%
%    channel    The channel to use with multi-channel data, cpi1-4 may
%               contain different channels in each column.
%
%    cpi1-4     The input data matricies (RSTER CPIs) (nPulseCPI*wrecord X
%               nChannels).

function [BigCPI, pulses] = bigcpi(wrecord, channel, cpi1, cpi2, cpi3, cpi4)

BigCPI = [cpi1(:,channel); cpi2(:,channel); cpi3(:,channel); cpi4(:,channel)];
pulses = length(BigCPI) / wrecord;
BigCPI = reshape(BigCPI, wrecord, pulses);