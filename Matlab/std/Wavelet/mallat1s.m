%MALLAT1S       Compute a single scale detail seq. of Mallat's decomposition.
%
%   [Decomp Filter]= mallat1s(Data, idxScale)
%
%   Decomp      The decomposed sequences. Each successive decomposition is
%               placed in a new column.
%
%   Filter      The filter impulse response used to generate the detail
%               sequence.
%
%   idxScale    The scale to be computed.  1 is equivalent to a scaled first
%               difference filter.
%
%   Data        The data sequence(s) to decompose.  If more than one sequence
%               is to be processed each sequence should be in a seperate 
%               column.  If only a single sequence is to be procecssed Data
%               should be a column vector.
%
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
%  $Log: mallat1s.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:25  rickg
%  Matlab Source
%
%  Revision 1.2  1997/04/08 20:59:08  rjg
%  Change iScale to idxScale except in counter for loop.  Confliting name
%  in MATLAB5.
%
%  Employed end description of vector index.
%
%  Revision 1.1  1996/10/09 15:44:49  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Decomp, Filter] = mallat1s(Data, idxScale)

%%
%%  Initializations
%%
[nSamples nSeq] = size(Data);
[h g] = wfc_qspl;

g = g(:);
h = h(:);

%%
%%  Convolve the filters to create a parallel filter bank.
%%
nH = length(h);
nG = length(g);
nLongFilter = 1 + (nH - 1) * (2^idxScale - 1);
Filter = zeros(nLongFilter,1);

%%
%%  gCurr - the expanded detail filter
%%  hCurr - the expanded smothing filter
%%  hTree - the filter required to get to the current decomposition level
%%
hTree = h;
hCurr = h;
gCurr = g;
gTree = g;
nFilt = length(gTree);
for iScale = 2:idxScale,

    %%
    %%  Expand both filters by 2
    %%
    hTemp = zeros(2 * length(hCurr) - 1, 1);
    hTemp(1:2:end) = hCurr;
    hCurr = hTemp;
   
    gTemp = zeros(2 * length(gCurr) - 1, 1);
    gTemp(1:2:end) = gCurr;
    gCurr = gTemp;

    gTree = conv(gCurr, hTree);
    hTree = conv(hCurr, hTree);
    
    nFilt = length(gTree);
end
Filter((nLongFilter-nFilt)/2+1:(nLongFilter+nFilt)/2) = gTree;

%%
%%  Trim the ends of the filter
%%
nEnd = 2 ^ (idxScale-1);
Filter = Filter([nEnd+1:nLongFilter-nEnd]);
nLongFilter = length(Filter);

%%
%%  Mirror the ends of the signal
%%
nMirror = ceil(nLongFilter) - 1;
nTop = ceil(nMirror/2);
nBottom = floor(nMirror/2);
DataMirr = [flipud(Data([1:nTop],:));
            Data;
            flipud(Data([nSamples-nBottom+1:nSamples],:))];

Decomp = zeros(nSamples, nSeq);

%%
%%  Process the mirrored signal through each filter
%%
for iSeq = 1:nSeq,
    temp = filter(Filter, 1, DataMirr(:,iSeq));
    Decomp(:, iSeq) = temp(nLongFilter:end);
end
