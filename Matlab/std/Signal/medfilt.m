%MEDFILT        Median filter
%   y = medfilt(x, Win)
%
%   y       Median filtered signal.
%
%   x       Signal to be filtered.
%
%   Win     The size of the filter window.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: medfilt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/22 22:01:29  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y=medfilt(X, Win);

nSamples = length(X);
X(nSamples+Win-1) = 0;

%%
%%  Create a matrix out of the input so that we can take the median of each
%%  column of the matrix.
%%
z = zeros(Win, nSamples);
for iDiag = 1:Win
    z(iDiag,:) = X(iDiag:nSamples+iDiag-1);
end

%%
%%  Take the median of each column
%%
Y = median(z);

%%
%%  Remove the last Win-1 samples, they contain padding zeros.
%%
Y = Y(1:nSamples-Win+1);
