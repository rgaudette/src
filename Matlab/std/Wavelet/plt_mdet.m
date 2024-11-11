%PLT_MDET       Plot the detail sequences from Mallat's decomposition.
%
%    hax = plt_mdet(Seq, nDecomp, xRange, yRange)
%
%    hax         Axes handles for each plot
%
%    Seq         The squence to decompose, this is displayed in the first plot.
%
%    nDecomp     The number of decompositions to perform.
%
%    xRange      [OPTIONAL] The x axis range for the plots.
%
%    yRange      [OPTIONAL] The y axis rang for the plots.  If this is a 2
%                element vector the y axis will be the same for all plots. If
%                it is a nDecomp x 2 matrix each row provides the y-axis range
%                for the corresponding plot.

function hax = plt_mdet(Seq, nDecomp, xRange, yRange)

%%
%%  Initializations
%%
if nargin > 2,
    xRange = xRange(:)';
    if nargin > 3,
        [nRow nCol] = size(yRange);
        if (nRow == 1) | (nCol == 1),
            yRange = ones(nDecomp+1,1) * yRange(:)';
        end
    end
end

%%
%%  Make sure the sequnce is a row vector
Seq = Seq(:)';

%%
%%  Decompose the sequence
%%
nSamples = length(Seq);
Seq = Seq(1:nSamples);
Decomp = mallat(Seq, nDecomp);

%%
%%  Remove the approximation sequence and insert the orginal sequence
%%
[nData nSeq] = size(Decomp);
Decomp = [Seq' Decomp(:, 1:nDecomp)];

%%
%%  Plot the sequences
%%
hax = matplot(Decomp);

%%
%%  Set the axis (if requested).
%%
hax = hax(:)';

if nargin > 2,
    for idxAxes = 1:length(hax),
        
        set(gcf, 'CurrentAxes', hax(idxAxes));

        Range = axis;
        Range(1:2) = xRange;

        if nargin > 3,
            Range(3:4) = yRange(idxAxes, :);
        end
        axis(Range);

        %%
        %%  Put title on graphs, search regions
        %%
        if idxAxes == 1,
            title('Original Sequence')
        else
            title(['Scale ' int2str(idxAxes-1) ' Detail Sequence']);
        end

    end
end