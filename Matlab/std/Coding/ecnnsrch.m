%ECNNSRCH       Entropy constrained nearest neighboor search.
%
%   [Cidx MSDiff] = ecnnsrch(Data, CodeBook, Entropy, Lambda)
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
%   Entropy     The entropy for each codeword in the codebook.
%
%   Lambda      The constraint parameter.
%
%

function [Cidx, MSDiff] = fsvq(Data, CodeBook, Entropy, Lambda)

%%
%%  Make sure the data and code vectors are the same length.
%%
[Drow Dcol] = size(Data);
[Crow Ccol] = size(CodeBook);

if Drow ~= Crow,
    error('Data vectors are not the same size as the code vectors');
end

%%
%%  For each data vector find the entropy (codeword length) constrained 
%%  nearest code vector
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
    J = sum(Diff .* Diff) + Lambda * Entropy;
    [val idx] = min(J);
    Cidx(idxDvec) = idx;
    MSDiff(idxDvec) = sum(Diff(:,idx).* Diff(:, idx));
end
MSDiff = MSDiff ./ nElem;

