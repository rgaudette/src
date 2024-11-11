%LBG            Use LBG algorithm to develop a vector codebook.
%
%   CodeBook = lbg(Training, InitCB, Epsilon)
%
%   CodeBook    The final codebook.
%
%   Training    The traning data to use to generate the code book.
%
%   InitCB      The initial code book, this also defines the size of the
%               codebook to generate.
%
%   Epsilon     The stopping criteria
%
%   ZeroThresh  The maximum number of vectors a cell may contain and still be
%               considered empty.

function CodeBook = lbg(Training, CodeBook, Epsilon, ZeroThresh)

%%
%%  Initialization
%%
[CodeSize nCodes] = size(CodeBook)
[junk nTrain] = size(Training);
Delta = 1e-8;

%%
%%  VQ the data with the initial codebook
%%
[Cidx MSDiff] = fsvq(Training, CodeBook);
AvgMSD = mean(MSDiff)
prevAvgMSD = 0;
lstEmptyCell =[];

while abs(AvgMSD - prevAvgMSD) > Epsilon,

    %%
    %%  Recompute the codebook
    %%
    for idxCurr = 1:nCodes,
        CurrSet = Training(:, find(Cidx == idxCurr));
        [junk nVec] = size(CurrSet);
        if nVec > ZeroThresh,
            CodeBook(:, idxCurr) = centroid(CurrSet);
        else
            lstEmptyCell = [lstEmptyCell idxCurr];
        end
    end

    %%
    %%  If there are any empty cells we need to split the cells with largest
    %%  average distortion.
    %%
    if length(lstEmptyCell)

        disp(['Empty cells: ' int2str(length(lstEmptyCell))]);
        
        %%
        %%  Compute the average distortion for each cell using the new
        %%  codebook.  Sort according the TOTAL average distortion.
        %%
        [Cidx MSDiff] = fsvq(Training, CodeBook);
        disp('Computing average distortion')
        AvgDist = zeros(nCodes,1);
        for i = 1:nCodes,
            idxTrain = find(Cidx == i);
            if length(idxTrain),
                AvgDist(i) = sum(MSDiff(idxTrain));
            end
        end    
                
        [sortMSD idxCellMSD] = sort(AvgDist);
        idxCellMSD = rev(idxCellMSD);
        
        %%
        %%  For each empty cell split the cell with current large distortion.
        %%      Extract the cell with the largest distortion.
        %%      Perturb its code
        %%      VQ the subset
        %%      Find the centroid of each new subset
        %%      Store these vectors back into the codebook
        %%      Update Training incides and MSD
        %%
        disp('Replacing empty cells')
        
        for idxEmpty = 1:length(lstEmptyCell),
            %%
            %%  Extract the cell with current largest average distortion.
            %%
            idxCellSplit = idxCellMSD(idxEmpty);
            idxTrain = find(idxCellSplit == Cidx);
            SubSet = Training(:, idxTrain);

            %%
            %%  Split the cell with a perturbed pair of code vectors.
            %%
            V = CodeBook(:, idxCellSplit);
            SplitBook = [V-Delta V+Delta];
            
            [idxSplit SplitMSD] = fsvq(SubSet, SplitBook);
            idxCellA = find(idxSplit == 1);
            idxCellB = find(idxSplit == 2);
            if length(idxCellA) == 0,
                error('Cell didn''t split')
            end
            if length(idxCellB) == 0,
                error('Cell didn''t split')
            end
            
            %%
            %%  Compute & Update the new pair of code book values
            %%  VA - old full cell index, vb - previous empty cell index.
            %%

            VA = centroid(SubSet(:, idxCellA));
            VB = centroid(SubSet(:, idxCellB));
            CodeBook(:, idxCellSplit) = centroid(SubSet(:, idxCellA));
            CodeBook(:, lstEmptyCell(idxEmpty)) = centroid(SubSet(:, idxCellB));

            %%
            %%  Update cell indicies (for training vectors switched to the new cell index)
            %%  and MSD for training data.
            %%
            Cidx(idxTrain(idxCellB)) = lstEmptyCell(idxEmpty) * ...
                                       ones(size(idxCellB));
            MSDiff(idxTrain(idxCellB)) = SplitMSD(idxCellB);
            MSDiff(idxTrain(idxCellA)) = SplitMSD(idxCellA);

        end

        disp('Done replacing empty cells')
        %%
        %%  Update loop vars
        %%
        prevAvgMSD = AvgMSD;
        AvgMSD = mean(MSDiff)

    %%
    %%  There are no empty cells, just need to requantize the traing vectors.
    %%
    else
        disp(['Empty cells: ' int2str(length(lstEmptyCell))]);
        [Cidx MSDiff] = fsvq(Training, CodeBook);        
        prevAvgMSD = AvgMSD;
        AvgMSD = mean(MSDiff)

    end

    lstEmptyCell = [];
end

