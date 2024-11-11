%MOT_EST        Block motion estimation using minimum block differences.
%
%   [MotX MotY] = mot_est(image1, image2, szBlk, szWin, winBlk)
%
%   MotX        This is a MxN matrix with the x-direction motion estimates for
%               each sub-block from image1 to image2.
%
%   MotY        This is a MxN matrix with the y-direction motion estimates for
%               each sub-block from image1 to image2.
%
%   image1,image2   The image to predict the motion in, they must be the same
%                   size.
%
%   szBlk       The block size to use for estimation.  This is a vector of the
%               form [BlkY BlkX].
%
%   szWin       The is the number of pixels in each block of image2 over which
%               the search will be perfomed.  This is a vector of the form
%               [WinY WinX].
%
%   winBlk      [OPTIONAL]  This is size of the actual window applied to
%               image1.  The default value is the same as szBlk thus no
%               overlapping block estimation is performed.  If winBlk is
%               greater than szBlk then overlapping estimation will be
%               performed.

function [MotX, MotY] = mot_est(image1, image2, szBlk, szWin, winBlk)

if nargin < 5,
    winBlk = szBlk;
end


%%
%%  Extract the image dimensions
%%
[nImgY nImgX] = size(image1);


%%
%%  Pad the border of image1 with zeros if overlapping estimation is to be
%%  performed. Make sure there is an equal number of right & left, top &
%%  bottom.
%%
winBlk = 2*ceil((winBlk - szBlk)./2) + szBlk;
tmp = zeros([nImgY nImgX] + winBlk - szBlk);
Offset = (winBlk - szBlk) ./ 2;
tmp([Offset(1)+1:Offset(1)+nImgY], [Offset(2)+1:Offset(2)+nImgX]) = image1;
image1 = tmp;
ImgDiff = zeros(size(image1));
[nImgDiffY nImgDiffX] = size(ImgDiff);


%%
%%  Pad the border of image2 to allow for both image shifting and overlapped
%%  estimation (if necessary).
%%
szWin = 2 * ceil((szWin - winBlk)./2) + winBlk;
tmp = zeros([nImgDiffY nImgDiffX] + szWin - winBlk );
py = szWin(1)/2 - winBlk(1)/2 + (nImgDiffY - nImgY)/2;
px = szWin(2)/2 - winBlk(1)/2 + (nImgDiffX - nImgX)/2;
tmp([py+1:py+nImgY], [px+1:px+nImgX]) = image2;
image2 = tmp;

%%
%%  Create block summation operators to extract and sum up sub-blocks of the
%%  difference matrix.
%%
nBlksX = nImgX / szBlk(2);
nBlksY = nImgY / szBlk(1);

ColWin = [1:winBlk(2)]' * ones(1,nBlksX);
ColStep = ones(winBlk(2), 1) * ([0:szBlk(2):nImgX-1] + [0:nBlksX-1]*nImgDiffY);
ColIdx = ColWin + ColStep;
ColIdx = ColIdx(:);
ColSumOp = zeros(nImgDiffX, nBlksX);
ColSumOp(ColIdx) = ones(size(ColIdx));
ColSumOp = sparse(ColSumOp);

RowWin = [1:winBlk(1)]' * ones(1,nBlksY);
RowStep = ones(winBlk(1), 1) * ([0:szBlk(1):nImgY-1] + [0:nBlksY-1]*nImgDiffX);
RowIdx = RowWin + RowStep;
RowIdx = RowIdx(:);
RowSumOp = zeros(nImgDiffX, nBlksX);
RowSumOp(RowIdx) = ones(size(RowIdx));
RowSumOp = RowSumOp';
RowSumOp = sparse(RowSumOp);

%%
%%  Initialize image difference, temp and block differnce vectors
%%
ImgDiff = zeros(nImgDiffY, nImgDiffY);
temp = zeros(nBlksY, nBlksX);
Shift = szWin - winBlk;
Diff = zeros(nBlksY*nBlksX, Shift(1)*Shift(2));

%%
%%  Loop over the difference between the window size and the block window.
%%

for dx = 1:Shift(2)+1,
    xvec = [dx:dx+nImgDiffX-1];
    DiffRow = (dx - 1) * (Shift(1)+1);
    for dy = 1:Shift(1)+1,
        ImgDiff = abs(image2([dy:dy+nImgDiffY-1], xvec) - image1);
        temp = RowSumOp * ImgDiff * ColSumOp;
        Diff(:, DiffRow+dy) = temp(:);
    end
end
[temp idxMinDiff] = min(Diff');
idxMinDiff = reshape(idxMinDiff, nBlksY, nBlksX);
MotY = rem(idxMinDiff-1, Shift(1)+1) + 1 - (Shift(1)/2 + 1);
MotX = floor((idxMinDiff-1) ./ (Shift(1)+1) - Shift(2)/2);

