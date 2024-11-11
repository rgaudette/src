function y=get_sm(x,i,j,nx,ny)
%
%  GET_SM  - Function to extract the (i,j)th submatrix y from
%            a matrix x consisting of nx by ny identically
%            dimensioned submatrices
%
%            Invocation:
%
%               y=get_sm(x,i,j,nx,ny)
%

[kk,mm]=size(x);
k=kk/nx;
m=mm/ny;
y=x((i-1)*k+1:i*k,(j-1)*m+1:j*m);
