%SURFANIM       Animate a surface sequence
%
%    surfanim(data, start, finish, bottom, top)

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
    zMin  = matmin(data);
end

if nargin < 5
    zMax = matmax(data);
end

%%
%%    Setup initial figure
%%
indx = start;
s = flipud(reshape(data(:,indx),16,16));

figure(1)
set(gcf, 'backingstore', 'on')
colormap(vibgyor(128))
h =  surf(s);
set(h,  'EraseMode', 'xor');
shading interp
colorbar
axis([1 16 1 16 zMin zMax])
xlabel('south')
ylabel('west')
grid
drawnow;

while indx <= finish
    s = flipud(reshape(data(:,indx),16,16));
    set(h, 'zdata', s);
%    h = surf(s);
%    set(gca, 'drawmode', 'fast');
%    set(h,  'EraseMode', 'none');
%    shading interp
%    xlabel('south')
%    ylabel('west')

%    axis([1 16 1 16 zMin zMax])
%    colormap(vibgyor(256))    
%    shading interp
%    grid
%    colorbar
    drawnow;
%    pause(1)
    indx = indx + 1;
end

