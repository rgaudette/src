%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program takes an image as input, and returns
% its one step wavelet decomposition (four smaller
% images stored in one image frame.)
%
% 	Program old_decomp1.m
% 	 by  Wei Sun
%   
%       input variables:
%	  img: input image matrix.
%
%	output variables:
%	  img: decomposition image matrix.
%
%	decomposition:
%	 a -------> LL
%	 d1 ------> LH
%	 d2 ------> HL
%	 d3 ------> HH
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img=old_decomp1(img);

%
% DECOMPOSITION
%
dim = size(img);
xximg=img;
%
% Begin wavelet decomposition
%
a=[];
d1=[];
d2=[];
d3=[];

% N = y dimension of image
N=dim(1);
Nj=N/2;

% M = x dimension of image
M=dim(2);
Mj=M/2;

%
% Create pyramid matrices
%
% Load in lowpass filter coefficients
hload6;

%
% Construct projections onto scaling function and wavelet spaces
%
temp1=[];
temp2=[];
% row-wise filtering
for I=1:N;
xx=xximg(I,:);
xw=old_dwt(h,xx);
x=xw(1:Mj);
y=xw((Mj+1):M);
temp1=[temp1 x];
temp2=[temp2 y];
end;

% column-wise filtering
temp11=zeros(Nj,Mj);
temp12=zeros(Nj,Mj);
for I=1:Mj;
xx=temp1(I,:);
xw=old_dwt(h,xx);
x=xw(1:Nj);
y=xw((Nj+1):N);
temp11(1:Nj,I)=x;
temp12(1:Nj,I)=y;
end;
% put into wavelet array
a=temp11;
d1=temp12;
%
temp11=zeros(Nj,Mj);
temp12=zeros(Nj,Mj);

for I=1:Mj;
xx=temp2(I,:);
xw=old_dwt(h,xx);
x=xw(1:Nj);
y=xw((Nj+1):N);
temp11(1:Nj,I)=x;
temp12(1:Nj,I)=y;
end;
% put into wavelet array
d2=temp11;
d3=temp12;
%
img=[a d1;d2 d3];

