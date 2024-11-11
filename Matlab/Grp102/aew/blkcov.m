function y=blkcov(u,np)
% Given u partitioned as [u1,u2,...,unp], where each ui has
% the same dimensions nj-times-nel. Compute the autocorrelation
% matrix of u, assuming that ui is uncorrelated with uj whenever 
% i .NE. j.
%
% nj  = number of jammers
%     = number of rows in ui.
% nel = number of elements
%     = number of columns in ui.
% np  = number of pulses
%     = number of blocks ui in u.
%
[nj,i]=size(u);                 % get number of jammers
nel=i/np;                       % compute number of elements
y=zeros(nel*np,nel*np);         % dimension the output matrix
%
for i=1:np
 ui=get_sm(u,1,i,1,np);         % get the ith block
 z=(ui')*ui;                    % autocorrelation matrix of ui
 y=put_sm(z,y,i,i);             % put it in
end
