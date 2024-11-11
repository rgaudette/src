%REV            Reverse a sequence.
%
%   y = rev(x)
%
%   y       The reversed sequence.
%
%   x       The sequence to be reversed, if x is matrix the sequences are
%           considered to be in each column.

function y = rev(x)

%%
%%  find the structure of the input sequence
%%
[n m] = size(x);

if n == 1,
    y = fliplr(x);

else
    y = flipud(x);
end

    
    
