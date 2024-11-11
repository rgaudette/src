%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: bi_decomp1.m
% Author: David F. Hoag
% Date: 11/30/94
%
% This program takes an image as input, and returns
% its 1-step bi-orthogonal wavelet decomposition. 
% Note bi_dwt.m is needed to run this program. 
%
% input: img ==> input image matrix
%
% output: img ==> decomposed image matrix
%
%                      -----------
%                      | LL | LH |
%        original ==>  -----------                
%         image        | HL | HH |
%                      -----------                
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img=bi_decomp1(img);

% Find x and y dimensions of input image 
[N,M] = size(img);

% Load in lowpass analysis and synthesis filter coefficients
bi_hload;

%
% Begin wavelet decomposition
%

% row-wise filtering
img = bi_dwt(h,h_tilde,img);
img = img';

% column-wise filtering
img = bi_dwt(h,h_tilde,img);
img = img';

% Extract LH component from lower left region 
% and swap it with HL component from upper right region

hl = img(1:N/2,(M/2+1):M);
lh = img((N/2+1):N,1:M/2);

img(1:N/2,(M/2+1):M) = lh;
img((N/2+1):N,1:M/2) = hl;









