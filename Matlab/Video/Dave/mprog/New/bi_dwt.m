%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: bi_dwt.m
% Author: David F. Hoag
% Date: 11/30/94
%
% This program takes a signal matrix f and computes a 
% row-wise 1-step bi-orthogonal wavelet decomposition.
%
% input: h       ==> lowpass analysis filter coefficients
%        h_tilde ==> lowpass synthesis filter coefficients
%        f       ==> signal matrix
% output: w ==> wavelet matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function w = bi_dwt(h,h_tilde,f);

% Find the dimensions of the input f
[ydim xdim] = size(f);
N = xdim;
n = N/2;

% Reflect rows of f about Nth pt. (Eg. f=[1 2 3 4] ==> new_f=[1 2 3 4 3 2])
% new_f is 2N-2 periodic
M = length(h);
f = [f fliplr(f(:,2:N-1))];

% Reflect f about 1st pt. with (M-1)/2 values, this sets up
% rows of f for a circular convolution with h and g
new_f = [fliplr(f(:,2:(M-1)/2+1)) f];

[new_f_ydim, new_f_xdim] = size(new_f);
L=zeros(n,new_f_xdim);

for i=1:n
    l=2*i-1;
    k=1;
    while (l<=new_f_xdim) & (k<=M)
  	  L(i,l) = h(k);
	  k = k + 1;
          l = l + 1;
    end;
end;
L=sparse(L);

% Construct quadrature mirror filter g from h_tilde
M1 = length(h_tilde);
g(2:2:M1) = -h_tilde(2:2:M1);
g(1:2:M1) = h_tilde(1:2:M1);
g = g(M1:-1:1);

% Construct the highpass and decimated by 2 H matrix
H=zeros(n,new_f_xdim-abs((M-1)/2-(M1-1)/2)-1);
for i=1:n
    l=2*i-1;
    k=1;
    while (l<=new_f_xdim-abs((M-1)/2-(M1-1)/2)-1) & (k<=M1)
          H(i,l) = g(k);
	  k = k + 1;
          l = l + 1;
    end;
end;
H=sparse(H);

% Compute lowpass version of the signal
a = (L*new_f').';

% Compute highpass version of the signal
b = (H*new_f(:,(2+abs((M-1)/2-(M1-1)/2)):new_f_xdim)').';

% Create wavelet vector w = [a b]
w = 1/sqrt(2)*[a b];

