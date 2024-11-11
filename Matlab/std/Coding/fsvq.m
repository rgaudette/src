%FSVQ           Full-Search Vector quantize a sequence for input vectors.
%
%   [Cidx MSDiff] = fsvq(Data, CodeBook)
%
%   Cidx        The codebook index for each vector in Data.
%
%   MSDiff      The mean square difference between each vector and its
%               selected code vetor.
%
%   Data        The matrix of data to be quantized, each vector is a column in
%               the matrix.
%
%   CodeBook    The code book to quantize the data with.
%
%       VQ finds the nearest neighboor code vector for each column vector in
%   the data matrix.  The index of the closest code vector is returned in Cidx
%   and the mean square difference is given in MSDiff.
%

function [Cidx, MSDiff] = fsvq(Data, CodeBook)

%%
%%  Make sure the data and code vectors are the same length.
%%
[Drow Dcol] = size(Data);
[Crow Ccol] = size(CodeBook);

if Drow ~= Crow,
    error('Data vectors are not the same size as the code vectors');
end

%%
%%  For each data vector find the nearest code vector
%%
one_vec = ones(1, Ccol);
DataMat = zeros(size(CodeBook));
Diff = zeros(size(CodeBook));
Cidx = zeros(1, Dcol);
MSDiff = zeros(1, Dcol);
[nElem nCodes] = size(CodeBook);

for idxDvec = 1:Dcol,
    DataMat = Data(:,idxDvec) * one_vec;
    Diff = CodeBook - DataMat;
    Diff = sum(Diff .* Diff);
    [val idx] = min(Diff);
    Cidx(idxDvec) = idx;
    MSDiff(idxDvec) = val;
end
MSDiff = MSDiff ./ nElem;

