%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: reconst1.m
% Author: David F. Hoag
% Date: 6/23/94
%
% This program reconstructs an image which has been 
% 1-step wavelet decomposed into 4 subbands.
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

function img=reconst1(img);

% Find x and y dimensions of decomposed image
dim = size(img);
N=dim(1);
M=dim(2);

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
hload6;

% Synthesize LL and LH
rec1=idwt(h,LL,LH);

% Synthesize HL and HH
rec2=idwt(h,HL,HH);

% Synthesize all components 
img = idwt(h,rec1,rec2);
img = img';
