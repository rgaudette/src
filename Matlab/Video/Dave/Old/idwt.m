%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: idwt.m
% Author: David F. Hoag
% Date: 6/23/94
%
% This program takes 2 subband matrices A and B, 
% row-wise synthesizes each then combines them.
%
% input: h ==> lowpass filter coefficients
%        A ==> lower subband signal matrix
%        B ==> upper subband signal matrix
% output: f ==> synthesized signal matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = idwt(h,A,B);

% Find the dimensions of input matrix A
[ydim, xdim]  = size(A);

% Construct flipped filters h and g 
g = qmf(h);
M = length(h);
h = h(M:-1:1);  
g = g(M:-1:1);

% Upsample by 2, the rows of A and B
dum = zeros(ydim,2*xdim);
i=1:2:(2*xdim);
j=1:xdim;
dum(:,i)=A(:,j);
A=dum;
clear dum;

dum = zeros(ydim,2*xdim); 
dum(:,i)=B(:,j); 
B=dum;
clear dum;

% Periodize the rows of the A and B matrices 
dum = zeros(ydim,(M-1));
A = [dum A];
B = [dum B];
clear dum;

for i=1:ydim
    for j=(M-1):-1:1
        A(i,j) = A(i,j+(2*xdim));
        B(i,j) = B(i,j+(2*xdim));
    end;
end;

% Construct lowpass interpolation filter
L = zeros((2*xdim),(2*xdim)+M-1);
for i=1:(2*xdim)
    l=i;
    k=1;
    while (l<=((2*xdim)+M-1)) & (k<=M)
          L(i,l) = h(k);
          k=k+1;
          l=l+1;
    end;
end;
L=sparse(L);

% Construct highpass interpolation filter 
H = zeros((2*xdim),(2*xdim)+M-1); 
for i=1:(2*xdim)
    l=i; 
    k=1; 
    while (l<=((2*xdim)+M-1)) & (k<=M) 
          H(i,l) = g(k); 
          k=k+1; 
          l=l+1; 
    end; 
end;

H=sparse(H);

% Interpolate A and B matrices, then combine in f
f = L*A' + H*B'; 

% Rescale f
f=(2.^0.5)*f;

clear L H A B;



