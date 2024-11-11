%WLGEN      Generate a mother wavelet representation by iterating and
%           downsampling the Approxiamtion filter reponse.
%
%   [Low High] = wlgen(n, Approx, Detail)
function [Low, High] = wlgen(n, Approx, Detail)
xin = [fliplr(Approx) zeros(1,10)];
for i = 1:n-1,
    xin = filter(Approx, 1, xin)
%    xin = xin(1:2:length(xin))
end
Low = filter(Approx, 1, xin);
%Low = Low(length(Approx):2:length(Low));
High = filter(Detail, 1, xin);
%High = High(1:2:length(High));