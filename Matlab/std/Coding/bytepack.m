%BYTEPACK       Pack a sequence of integers into a sequence of bytes.
%
%   Bytes = bytepack(Seq, nBits)
%
%   Bytes       The packed output sequence, each element is byte thus
%               all elements in the vector will lie between 0 and 255.
%
%   Seq         The seqeunce of integers to be coded.
%
%   nBits       [OPTIONAL] The number of bits necessary to code each integer
%               in the sequence.  If this is not provided it will be
%               computed from the data.
%
%       BYTEPACK maps a sequence of integers into a packed byte
%   representation.  The sequence must be within the range of 0:2^nBits.
%
%   Note: the maximum value for nBits is 14.

function Bytes = bytepack(Seq, nBits)

minVal = min(Seq);
maxVal = max(Seq);

%%
%%  Compute nBits if not supplied.
%%
if nargin < 2,
    nBits = ceil(log2(maxVal))
end

%%
%%  Error checking
%%
if minVal < 0,
    error('All integers must be non-negative');
end
if maxVal > 2^nBits-1,
    error('Not enough bits to encode largest values in sequence.');
end

%%
%%  Calculate the total number of bits necessary to store the sequence
%%
nIdx = length(Seq);
nBytes = ceil(nIdx * nBits / 8)
bitSequence = zeros(nBytes * 8, 1);

%%
%%  Convert the sequnce into a bit stream
%%
PosVec = 2.^[0:nBits];
idxBitSeq = 0;
for idxSeq = 1:nIdx,
    CurrVal = Seq(idxSeq);
    for idxBit = nBits:-1:1,

        idxBitSeq = idxBitSeq + 1;
        CurrPow = PosVec(idxBit);

        if CurrVal >= CurrPow
            bitSequence(idxBitSeq) = 1;
            CurrVal = CurrVal - CurrPow;
        else
            bitSequence(idxBitSeq) = 0;
        end

    end
end

%%
%%  Convert the bit stream into a sequence of unsigned byte values.
%%
ByteVal = [128 64 32 16 8 4 2 1]' * ones(1, nBytes);
Bytes = sum(reshape(bitSequence, 8, nBytes) .* ByteVal);

