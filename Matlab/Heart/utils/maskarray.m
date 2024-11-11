%MASKARRAY      Mask out the border of a lead array.
%
%   Masked = maskarray(Data, szArray);
%
%   Masked      The masked out lead array.
%
%   Data        Lead data.
%
%   szArray     Array size [nRows nCols]
%
%   wdBorder    The width of the border to mask out.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:45 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: maskarray.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:45  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Masked = maskarray(Data, szArray, wdBorder)

if nargin < 3
    error('Incorrect call');
end


%%
%%  Create a template matrix of the mask
%%
mask = ones(szArray(1), szArray(2));
mask(1:wdBorder, :) = zeros(wdBorder, szArray(2));
mask(szArray(1)-wdBorder+1:szArray(1), :) = zeros(wdBorder, szArray(2));
mask(:, 1:wdBorder) = zeros(szArray(1), wdBorder);
mask(:, szArray(2)-wdBorder+1:szArray(2)) = zeros(szArray(1), wdBorder);
mask = find(mask(:));
%%
%%  Copy the masked data into the new array
%%
Masked = zeros(size(Data));
Masked(mask, :) = Data(mask, :);
