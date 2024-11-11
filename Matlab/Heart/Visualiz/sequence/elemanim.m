%ELEMANIM       Animate a surface sequence
%
%    elemanim(data, start, finish, bottom, top)

function elemanim(data, start, finish, bottom, top)

%%
%%  Scale data appropriately
%%
data = data ./ 1E6;
[nRows nCols] = size(data);

if nargin < 2,
    start = 1;
end

if nargin < 3
    finish = nRows;
end

if nargin < 4
    zMin  = matmin(data);
end

if nargin < 5
    zMax = matmax(data);
end

%%
%%    Setup initial figure
%%
indx = start;
figure(1)
h = plot(data(indx,:));
axis([0 nCols zMin zMax]);
set(h,  'EraseMode', 'none');
%hold on

while indx <= finish
%    figure(1)

%    h = plot(data(indx,:));
%    set(h,  'EraseMode', 'none');
    set(h,  'zData', data(indx,:));
%    axis([0 nCols zMin zMax]);
    drawnow;

%    figure(2)
%    h = plot(diff(data(indx,:)));
%    set(h,  'EraseMode', 'none');
%    axis([0 nCols -.01 .01]);
%    drawnow;

    indx = indx + 1;
end

