%RATEDIST   Compute the rate-distortion curve for a given set of codebooks.
%
%   [rate dist RateEntropy] = ratedist(FileMap, SourceData, flgType)
%
%   rate    The rate of each selected codebook (from the file map fct).
%
%   dist    The mean square distortion of each codebook.
%
%   FileMap A string with the function name to create the code book file
%           map, rates and optionally lambda for EC codebooks.
%
%   SourceData  A column vector of the data to compute the distortion.
%
%   flgType The type of codebooks to expect:
%           0 - standard codebooks, no entropy computation
%           1 - transposed (Dave's) code books, no entropy computation
%           2 - standard codebooks, with entropy computation.

function [rate, dist, RateEntropy] = ratedist(FileMap, SourceData, flgType)

if nargin < 2,
    flgType = 0;
end
if flgType == 0,
    Transposed = 0;
    flgECVQ = 0;
elseif flgType == 1,
    Transposed = 1;
    flgECVQ = 0;
elseif flgType == 2,
    Transposed = 0;
    flgECVQ = 1;
else
    error('RATEDIST: Improper flgType parameter');
end


%%
%%  Run the File Mapping routine
%%
if flgECVQ,
    [rate codebook Lambda] = feval(FileMap);
else
    [rate codebook] = feval(FileMap);
end

[nRates junk] = size(rate);
dist = zeros(1,nRates);
RateEntropy = zeros(1, nRates);
nSource = length(SourceData);

%%
%%   Loop over each codebook computing it's MSD
%%
for iRate = 1:nRates,
    disp(['iRate: ' int2str(iRate)]);
    disp(deblank(codebook(iRate,:)));
    %%
    %%  Load in the codebook to be tested
    %%
    load(deblank(codebook(iRate,:)));

    if Transposed,
        [nCodes nElem] = size(VQ);
    else
        [nElem nCodes] = size(VQ);
    end
    
    %%
    %%  Reshape the source matrix
    %%
    TempSource = SourceData(1:(nSource - rem(nSource, nElem)));
    nVecs = length(TempSource) / nElem;
    TempSource = reshape(TempSource, nElem, nVecs);

    %%
    %%  Vector quantize reshaped source data
    %%
    if Transposed,
        [cidx mse] = fsvq(TempSource, VQ');
    else        
        if flgECVQ,
            [cidx mse] = ecnnsrch(TempSource, VQ, Entropy, Lambda(iRate));
            RateEntropy(iRate) = sum(Entropy(cidx)) / nVecs / nElem;
        else
            [cidx mse] = fsvq(TempSource, VQ);
        end
    end
    dist(iRate) = mean(mse);

end

