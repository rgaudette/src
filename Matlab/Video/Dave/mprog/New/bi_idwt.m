%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: bi_idwt.m
% Author: David F. Hoag
% Date: 12/5/94
%
% This program takes 2 subband matrices A and B, 
% row-wise synthesizes each then combines them.
%
% input: h ==> lowpass analysis filter coefficients
%        h_tilde ==> lowpass synthesis filter coefficients
%        A ==> lower subband signal matrix
%        B ==> upper subband signal matrix
% output: f ==> synthesized signal matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = bi_idwt(h,h_tilde,A,B);

% Find the dimensions of input matrix A
[ydim,xdim] = size(A);

% Construct quadrature mirror filter g_tilde from h
M = length(h);
M1 = length(h_tilde); 
g_tilde(2:2:M) = h(2:2:M);
g_tilde(1:2:M) = -h(1:2:M);  
g_tilde = g_tilde(M:-1:1);

% Construct xdim-1 periodic extension of A row coefficients
% Eg. [1 2 3 4] ==> [1 2 3 4 4 3 2]
A = [A A(:,xdim:-1:2)];

% Construct xdim-1 periodic extension of B row coefficients
% Eg. [1 2 3 4] ==> [1 2 3 4 3 2 1]
B = [B B(:,xdim-1:-1:1)];

% Upsample rows of A and B
new_A = zeros(ydim,2*length(A(1,:)));
new_A(:,1:2:2*length(A(1,:))) = A;

[new_A_ydim, new_A_xdim] = size(new_A); 
new_B = zeros(ydim,2*length(B(1,:)));
new_B(:,1:2:2*length(B(1,:))) = B;
[new_B_ydim, new_B_xdim] = size(new_B);

% Construct matrix which performs a circular convolution
% of the lowpass interpolation filter (h_tilde) with new_A
r = zeros(1, new_A_xdim);
r([1:(M1+1)/2]) = h_tilde([(M1+3)/2-1:-1:1]);
r([new_A_xdim:-1:new_A_xdim+1-(M1-1)/2]) = h_tilde([(M1+1)/2+1:M1]);
c = flipud([r(2:new_A_xdim) r(1)].');
c = c(1:2*xdim);
L = toeplitz(c, r);
L=sparse(L);

% Construct matrix which performs a circular convolution
% of the highpass interpolation filter (g_tilde) with new_B
r = zeros(1, new_B_xdim);
r([1:(M-1)/2]) = g_tilde([(M+1)/2-1:-1:1]);
r([new_B_xdim:-1:new_B_xdim+1-(M+1)/2]) = g_tilde([(M-1)/2+1:M]);
c = flipud([r(2:new_A_xdim) r(1)].');
c = c(1:2*xdim);
H = toeplitz(c, r);
H=sparse(H);

% Interpolate A and B matrices, then combine in f
f = L*new_A' + H*new_B'; 

% Rescale f
f=(2.^0.5)*f;

