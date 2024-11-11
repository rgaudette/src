%SUB13		Perform a 13 element average and sub-sample by 13.  This
%		function was created for hot clutter RD map processing because
%		the range dimension is oversampled by 13.
%

function y = sub13(x);
%%
%%    Compute sizes needed for processing.
%%
[nrow ncol] = size(x);
nsamp = nrow / 13;


%%
%%    Initialize filter matrix.    
%%
filter = zeros(nrow, nsamp);

%%
%%    Generate filter.  Each column is a sequence of 13 ones, each column
%%  starts the sequence 13 samples later than the previous column.  Thus
%%  multiplying this filter by a row vector effective sub-samples the vector.
%%
for isamp = 1:nsamp,
   filter((isamp-1)*13+1:isamp*13,isamp) = ones(13,1) / 13;
end

%%
%%    Apply filter to columns by transposing data matrix and multplying.
%%
y = x.' * filter;
y = y.';