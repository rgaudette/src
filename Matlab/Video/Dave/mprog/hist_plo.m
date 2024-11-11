%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function takes the input matrix and normalizes it
% as (x-x_mean)/x_stdev. The normalized dat is then plotted 
% with a Laplacian distribution (mean=0, std=1) for 
% comparison.  
%
% author: David Hoag
%
% function: hist_plot.m   
%
% input: x ==> input matrix 
%        N ==> # of bins for histogram
%        
% output: plot 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function norm_x = hist_plot(x,N);

dimension = size(x);
ysize = dimension(1);
xsize = dimension(2);

% Convert data into vector
data(:) = x;

% normalize the data
norm_x = (data-mean(data))/std(data);

% Call histogram function
% `y' is the vector of intervals
% `n' is the # of elements/bin
[n,y]=hist(norm_x,N);

% Normalize n
norm_n = n/sum(n);

% Divide norm_n by interval width since approx. a cont. density
delta = (max(norm_x)-min(norm_x))/N;
dist = norm_n/delta;
max(dist)

% Plot the data distribution
plot(y,dist,'--')
hold

% Generate plot for the Laplacian
min_abs = abs(min(norm_x));
endpt = max(min_abs, max(norm_x));

delta_lap = 2*endpt/(N+1);

i = -endpt:delta_lap:-.00001;
lapl_left = .5*exp(-abs(i));

j = 0:delta_lap:endpt;
lapl_right = .5*exp(-j);

k = [i j];
lapl = [lapl_left lapl_right];

plot(k,lapl)

xlabel('x');
ylabel('p(x)');
text(1,.7,'dashed line: Actual dist.');
text(1,.8,'solid line: Laplacian dist.');

y_max = max(1,max(dist));
axis([-endpt endpt 0 y_max]);
