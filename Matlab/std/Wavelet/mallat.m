%MALLAT         Perform Mallat's decomposition on a vector sequence.
%   
%   Decomp = mallat(Data, nDecomp)
%
%   Decomp      The scales of the decomposed seqeunce.  The finest scale
%               detail sequence is in the first column, the coarsest scale
%               detail seqeunce is in the second to last column and coarse
%               approximation sequence is in the last column.
%               (nData x nDecomp+1)
%
%   Data        The vector to decompose.
%
%   nDecomp     The number of decompositions (scales) to compute.  If not
%               present as an input argument, as many decompositions as the
%               length of the data sequence allows will be performed.
%
%   NOTE:  The algorithm now scales all of the detail coefficeints to
%          return a constant local maximum across scales for a step function.
%
%   Ref: Characterization of Signals from Multiscale Edges
%       Mallat & Zhong, IEEE Transactions on Pattern Analysis and Machine
%       Intelligence, Vol 14, No. 7, July 1992, pp 710-732
%
%   Calls: wfc_qspl.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:25 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mallat.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:25  rickg
%  Matlab Source
%
%  Revision 1.2  1997/06/05 18:28:14  rjg
%  Changed size to length for MATLAB 5
%
%  Revision 1.1  1996/11/09 19:08:09  rjg
%  Initial revision
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Decomp = mallat(Data, nDecomp)

%%
%%  Initializations
%%
[h g] = wfc_qspl;
Data = Data(:);
g = g(:);
h = h(:);

%%
%%  Convolve the filters to create a parallel filter bank.
%%
nH = length(h);
nLongFilter = 1 + (nH - 1) * (2^nDecomp - 1);
Filters = zeros(nLongFilter, nDecomp+1);
Filters((nLongFilter-4)/2+1:(nLongFilter+4)/2, 1) = g;

%%
%%  gCurr - the expanded detail filter
%%  hCurr - the expanded smothing filter
%%  hTree - the filter required to get to the current decomposition level
%%
hTree = h;
hCurr = h;
gCurr = g;

%%
%%  For each scale generate a combined filter to produce the requested detail
%%  sequences.
%%
for iDecomp = 2:nDecomp,

    %%
    %%  Expand both filters by 2
    %%
    hTemp = zeros(2 * length(hCurr) - 1, 1);
    hTemp(1:2:length(hTemp)) = hCurr;
    hCurr = hTemp;
   
    gTemp = zeros(2 * length(gCurr) - 1, 1);
    gTemp(1:2:length(gTemp)) = gCurr;
    gCurr = gTemp;

    gTree = conv(gCurr, hTree);
    hTree = conv(hCurr, hTree);
    
    nFilt = length(gTree);
    Filters((nLongFilter-nFilt)/2+1:(nLongFilter+nFilt)/2, iDecomp) = ...
        gTree * ...
        ((2 .^ ( 2 * (iDecomp - 1))) / (1 + sum(2 .^(2 * [0:iDecomp-2] + 1))));
end
Filters(:, nDecomp+1) = hTree;


%%
%%  Mirror the ends of the signal
%%
nMirror = ceil(nLongFilter) - 1;
nData = length(Data);
nTop = ceil(nMirror/2);
nBottom = floor(nMirror/2);
DataMirr = [flipud(Data(1:nTop));
            Data;
            flipud(Data(nData-nBottom+1:nData))];

Decomp = zeros(nData, nDecomp+1);

%%
%%  Process the mirrored signal through each filter
%%
for iDecomp = 1:nDecomp+1,
    temp = filter(Filters(:,iDecomp), 1, DataMirr);
    nTemp = length(temp);
    Decomp(:, iDecomp) = temp(nLongFilter:nTemp);
end