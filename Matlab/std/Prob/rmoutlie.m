%RMOUTLIE       Remove outliers for a sample set.

function y = rmoutlie(x)

%%
%%  Plot a histogram of the data
%%
hist(x)

%%
%%  Get the min and max limits
%%
low = input('Enter the lower limit to include: ');
high = input('Enter the upper limit to include: ');

idxInclude = find(x >= low & x <= high);

y = x(idxInclude);

