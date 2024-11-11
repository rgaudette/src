%LAPLACIAN      Returns the discrete Laplacian operator.
%
%   l = laplacian(n, flgSparse)
%
%   l           The discrete Laplacian operator.
%
%   n           The opertor dimension
%
%   flgSparse   OPTIONAL: Create the operator as a sparse matrix, the
%               default is a dense (normal) matrix.
%
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:23:58 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: laplacian.m,v $
%  Revision 1.1.1.1  2004/01/03 08:23:58  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function l = laplacian(n, flgSparse)

%%
%%  Create the requested type of matrix  
%%
if nargin < 2
    flgSparse = 0;
end

if flgSparse
    %%
    %%  Create the diagonal vector
    %%
    i = [1:n]';
    j = [1:n]';
    s = 2 * ones(n,1);
    
    %%
    %%  Create the lower and upper diagonal
    %%
    i = [i; [2:n]'];
    j = [j; [1:n-1]'];
    s = [s; -1*ones(n-1,1)];
    
    i = [i; [1:n-1]'];
    j = [j; [2:n]'];
    s = [s; -1*ones(n-1,1)];
    
    l = sparse(i, j, s, n, n);
else
    %%
    %%  Dense laplacian operator
    %%
    l = 2 * diag(ones(n,1)) + ...
        -1 * diag(ones(n-1, 1), 1) + ...
        -1 * diag(ones(n-1, 1), -1);
end
