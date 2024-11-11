function y=put_sm(u,x,i,j)
%
% PUT_SM - Store u as the (i,j)th submatrix of x, return
%	   result as y.
%
%	   Invocation:
%
% 		y=put_sm(u,x,i,j)
[k,m]=size(u);
x((i-1)*k+1:i*k,(j-1)*m+1:j*m)=u;
y=x;
