%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: decomp1.m
% Author: David F. Hoag
% Date: 6/22/94
%
% This program takes an image as input, and returns
% its 1-step wavelet decomposition. Note dwt.m is needed
% to run this program. 
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

function img=decomp1(img);

% Find x and y dimensions of input image 
dim = size(img);
N = dim(1);
M = dim(2);

% Load in lowpass filter coefficients
hload6;

%
% Begin wavelet decomposition
%

% row-wise filtering
img = dwt(h,img);
img = img';

% column-wise filtering
img = dwt(h,img);
img = img';

% Extract LH component from lower left region 
% and swap it with HL component from upper right region

hl = img(1:N/2,(M/2+1):M);
lh = img((N/2+1):N,1:M/2);

img(1:N/2,(M/2+1):M) = lh;
img((N/2+1):N,1:M/2) = hl;
