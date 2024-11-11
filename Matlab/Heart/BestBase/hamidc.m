%HAMIDC         Hamid's cost function for segmenting ECG signals using CP.
%
%   c = hamidc(CosPackets, Signal)

function c = hamidc(CosPackets, Signal)

Signal = Signal ./ max(abs(Signal));
c = CosPackets .* conj(CosPackets);
ind = find(c > 0);

%%
%%  Median filter the signal
%%
xy = medfilt(Signal, 10);

%%
%%  Modified cost function, proportional to 1st & 2nd derivative
%%  of original signal (median filtered).
%%
%yy = abs(sum(diff(xy,1)))
%yy = sum(abs(diff(xy,1)))
%yyy = sum(abs(diff(xy,2)))
%y = exp(-yy)*abs(diff(xy,2))
%modifier =  exp(-1*exp(-yy)*yyy)
%modifier =  exp(-1*yyy)

%%
%%  Measure of curvature
%%
dy2 = diff(xy, 2);
dy1 = diff(xy, 1);
dy1 = 1:length(dy1)-1;
k = 1./length(Signal)*sum(dy2 ./ (sqrt(1+dy1.^2)))
c = -sum(c(ind) .* log(c(ind)))+k


