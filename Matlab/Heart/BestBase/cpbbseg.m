%CPBBSEG        Cosine packet best-basis segement
%
%   cpbbseg(x, Depth)

function [CosPackets,  btree, vtree] = cpbbseg(x, Depth)

%%
%%  Initialization
%%
Bell = 'Sine';
CostFct = 'Entropy';

%%
%%  Decompose, compute cost for each node, search for best basis
%%
CosPackets = CPAnalysis(x, Depth, Bell);
CostTree = cstreemod(CosPackets, CostFct, x);
[btree vtree] = BestBasis(CostTree, Depth);
%%
%%  Display segmentation
%%
lenSignal = length(x);
plot(x)
AxisRng = axis;
yRange = AxisRng(4) - AxisRng(3);
LineLimit = [AxisRng(3)+0.1*yRange AxisRng(4)-0.1*yRange]';
hold on

idxStart = 2;
nBlocks = 2;
nNodes = length(btree);
while idxStart+nBlocks-1 <= nNodes,
    vecNodes = btree(idxStart:idxStart+nBlocks-1);
    SegmEnds = find(vecNodes);
    if ~isempty(SegmEnds)
        SegmBegs = SegmEnds - 1;
        %%
        %%  Create vertical lines marking beginning & end of each segement
        %%
        SegmBegs = SegmBegs ./ nBlocks * lenSignal;
        SegmEnds = SegmEnds ./ nBlocks * lenSignal;
        plot(ones(2,1) * SegmBegs, LineLimit * ones(size(SegmBegs)), 'r');
        plot(ones(2,1) * SegmEnds, LineLimit * ones(size(SegmEnds)), 'r');
    end

    idxStart = idxStart + nBlocks;
    nBlocks = nBlocks * 2;
end
hold off