%PCOLANIM       Animate a surface sequence
%
%    pcolanim(data, start, finish, bottom, top)

function surfanim(data, start, finish, bottom, top)

%%
%%  Scale data appropriately
%%
data = data ./ 1E6;
[nRows nCols] = size(data);

if nargin < 2,
    start = 1;
end

if nargin < 3
    finish = nCols;
end

if nargin < 4
    zMin  = min(min(data(:,start:finish)))
end

if nargin < 5
    zMax = max(max(data(:,start:finish)))
end

%%
%%    Setup initial figure
%%
indx = start;
s = flipud(reshape(data(:,indx),16,16));

figure(1)
colormap(vibgyor(512))
h =  pcolor(s);
set(h,  'EraseMode', 'none');

colorbar
axis([1 16 1 16])
grid

while indx <= finish
    s = flipud(reshape(data(:,indx),16,16));
    h = pcolor(s);
    set(h,  'EraseMode', 'none');
%    axis([1 16 1 16])
    colormap(vibgyor(512))    
    shading flat
    colorbar
    drawnow;
    indx = indx + 1;
end

