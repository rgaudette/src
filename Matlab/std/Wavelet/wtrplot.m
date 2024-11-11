%WTRPLOT        Plot the mean & variance of the scales of a WT.
%
%	wtrplot(x, h, g, Edges)
%
%	x			The signal to be decomposed.
%
%	h			The approximation filter.
%
%   g           The detail filter.
%
%	Edges		[Optional] Specify edge processing.

function wtrplot(x, h, g, Edges)

if nargin < 4,
	Edges = 'zero';
end

%%
%%  Compute the wavelet transform of the signal reversing the filters, using
%%  the appropriate edge processing.
%%
if strcmp(Edges, 'zero'),
    [wt map] = recwt(x, rev(h), rev(g));

elseif strcmp(Edges, 'mirror'),
    [wt map] = recwtm(x, rev(h), rev(g));

elseif strcmp(Edges, 'period'),
    [wt map] = recwtp(x, rev(h), rev(g));
else
    error('Unknown edge processing selection.');
end

nScale = length(map);
Start = [1 (cumsum(map(1:nScale-1))+1)];
Stop = cumsum(map);
svar = zeros(1, nScale);
smean = zeros(1, nScale);

for iScale = 1:nScale,
    svar(iScale) = var(wt(Start(iScale):Stop(iScale)));
    smean(iScale) = mean(wt(Start(iScale):Stop(iScale)));
end
semilogy([1:length(svar)],svar, 'g');
xlabel('Scale Index')
ylabel('Variance')
grid


