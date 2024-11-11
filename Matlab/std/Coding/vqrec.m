%VQREC          Reconstruct a vector quantized sequence.
%
%   seq = vqrec(Cidx, CodeBook)
%

function seq = vqrec(Cidx, CodeBook)

seq = CodeBook(:, Cidx);
seq = seq(:);


