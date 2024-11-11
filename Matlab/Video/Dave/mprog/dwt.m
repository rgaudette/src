%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: dwt.m
% Author: David F. Hoag
% Date: 6/22/94
%
% This program takes a signal matrix f and computes a 
% row-wise 1-step wavelet decomposition.
%
% input: h ==> lowpass filter coefficients
%        f ==> signal matrix
% output: w ==> wavelet matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function w = dwt(h,f)

% Find the dimensions of the input f
[ydim, xdim] = size(f);

% Periodize f to avoid edge effects
M = length(h);
for i=1:ydim
    for j=1:(M-1)
        f(i,j+xdim) = f(i,j);
    end;
end;

% Construct the lowpass and decimated by 2 L matrix
L = zeros(xdim/2,(xdim+M-1));
for i=1:xdim/2  
    l=2*i-1;  
    k=1;   
    while (l<=(xdim+M-1)) & (k<=M)
      L(i,l)=h(k);
      k=k+1;
      l=l+1;
    end;    
end; 
L=sparse(L);

% Construct quadrature mirror filter g
g(2:2:M) = h(2:2:M);
g(1:2:M) = -h(1:2:M);
g = g(M:-1:1);

% Construct the highpass and decimated by 2 H matrix 
H = zeros(xdim/2,(xdim+M-1)); 
for i=1:xdim/2 
    l=2*i-1;   
    k=1;
    while (l<=(xdim+M-1)) & (k<=M) 
          H(i,l)=g(k);
          k=k+1;
          l=l+1;
    end;
end;
H=sparse(H);
     
% Compute lowpass version of the signal
a = (L*f').';

% Compute highpass version of the signal
b = (H*f').';

% Create wavelet vector w = [a b]
w = 1/sqrt(2)*[a b];
