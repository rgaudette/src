%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: bi_reconst1_1D.m
% Author: David F. Hoag
% Date: 12/6/94
%
% This program reconstructs a 1D signal which has been 
% 1-step biorthogonal wavelet decomposed into 2 subbands.
%
% input: sig ==> decomposed signal vector
%
% output: rec ==> reconstructed signal vector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rec=bi_reconst1_1D(sig);

% Find x and y dimensions of decomposed image
N = length(sig);

% Extract 2 subbands
L = sig(1:N/2);
H = sig(N/2+1:N);

% Load lowpass synthesis filter
bi_hload;

% Synthesize L and H
rec=bi_idwt_1D(h,h_tilde,L,H);


