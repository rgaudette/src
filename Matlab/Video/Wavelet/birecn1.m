%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: bi_reconst1.m
% Author: David F. Hoag
% Date: 11/30/94
%
% This program reconstructs an image which has been 
% 1-step biorthogonal wavelet decomposed into 4 subbands.
%
% input: img ==> decomposed image matrix
%
% output: img ==> reconstructed image matrix
%
%             -----------
%             | LL | LH |
%             -----------  ==> reconstructed
%             | HL | HH |         image
%             -----------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img=bi_reconst1(img);

% Find x and y dimensions of decomposed image
[N,M] = size(img);

% Extract 4 subbands
LL = img(1:N/2,1:M/2);
LH = img(1:N/2,(1+M/2):M);
HL = img((1+N/2):N,1:M/2);
HH = img((1+N/2):N,(1+M/2):M);

% Transpose subbands for columnwise filtering
LL = LL';
LH = LH';
HL = HL';
HH = HH';

% Load lowpass synthesis filter
bi_hload;

% Synthesize LL and LH
rec1=bi_idwt(h,h_tilde,LL,LH);

% Synthesize HL and HH
rec2=bi_idwt(h,h_tilde,HL,HH);

% Synthesize all components 
img = bi_idwt(h,h_tilde,rec1,rec2);
img = img';


