%SUM_1N_EXTR    Sum of the 1-norm of the sequence extrema
%
%   sum = sum_1n_extr(seq, thresh)
%
%   sum         Output sum
%
%   seq         The sequence to analyze
%
%   thresh      [OPTIONAL] A threshold for the magnitude of the extrema
%               (default: 0)
%
%
%   Calls: peaksrch
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:20 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: sum_1n_peak.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sum_out = sum_1n_extr(seq, thresh)

%%
%%  Find the signal extremas
%%
[maxima] = peaksrch(abs(seq));
%[minima] = dipsrch(seq);

%%
%%  Threshold those values if requested
%%

%%
%%  Sum 1-norm the extrema values
%%
sum_out = sum(abs(maxima));% + sum(abs(minima));




