%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program: bi_idwt_1D.m
% Author: David F. Hoag
% Date: 12/6/94
%
% This program takes 2 subband vectors A and B, 
% synthesizes each, then combines them.
%
% input: h ==> lowpass filter coefficients
%        A ==> lower subband signal vector
%        B ==> upper subband signal vector
% output: rec ==> synthesized signal vector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rec = bi_idwt_1D(h,h_tilde,A,B)

% Find the dimensions of input vector A
N = length(A);

% Construct flipped filters h and g
M = length(h);
M1 = length(h_tilde); 
g_tilde(2:2:M) = h(2:2:M);
g_tilde(1:2:M) = -h(1:2:M);  
g_tilde = g_tilde(M:-1:1);

% Construct N-1 periodic extension of A coefficients
% Eg. [1 2 3 4] ==> [1 2 3 4 4 3 2]
for j=1:N-1
    A(N+j) = A(N-(j-1));
end;

% Construct N-1 periodization of B coefficients
% Eg. [1 2 3 4] ==> [1 2 3 4 3 2 1]
for j=1:N-1
    B(N+j) = B(N-j);
end;

% Upsample A and B
new_A = zeros(1,2*length(A));
new_A(1:2:2*length(A)) = A; 
new_B = zeros(1,2*length(B));
new_B(1:2:2*length(B)) = B; 

% Construct matrix which performs a circular convolution
% of the lowpass interpolation filter (h_tilde) with new_A
L = zeros((2*N),length(new_A));

% Set up 1st row of the circ. conv. matrix
for j=1:(M1+1)/2
    L(1,j) = h_tilde((M1+3)/2-j);
end;
for j=1:(M1-1)/2
    L(1,length(new_A)+1-j) = h_tilde((M1+1)/2+j);
end;

for i=1:(2*N-1)
    L(i+1,1)=L(i,length(new_A));
    for j=1:length(new_A)-1
        L(i+1,j+1)=L(i,j);
    end;
end;
L=sparse(L);

% Construct matrix which performs a circular convolution
% of the highpass interpolation filter (g_tilde) with new_B
H = zeros((2*N),length(new_B));

% Set up 1st row of the circ. conv. matrix
for j=1:(M-1)/2
    H(1,j) = g_tilde((M+1)/2-j);
end;
for j=1:(M+1)/2
    H(1,length(new_B)+1-j) = g_tilde((M-1)/2+j);
end;

for i=1:(2*N-1)
    H(i+1,1)=H(i,length(new_B));
    for j=1:length(new_B)-1
        H(i+1,j+1)=H(i,j);
    end;
end;
H=sparse(H);

% Interpolate A and B matrices, then combine in f
rec = L*new_A' + H*new_B'; 

% Rescale f
rec = (2.0^0.5)*rec;
