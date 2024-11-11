%RASMOV         Make a movie out of a given sun raster seqeunce
%
%   [Movie] = rasmov(fname, start, stop)

function [Movie] = rasmov(fname, start, stop)

strStart = sprintf('%03d', start);
[Image Cmap]= rdsunras([fname '.' strStart]);
%colormap(Cmap);
image(Image);
set(gca, 'visible', 'off');
Movie = moviein(stop - start + 1);

for idx = start:stop,
    strIDX = sprintf('%03d', idx);
    disp([fname '.' strIDX])
    Image = rdsunras([fname '.' strIDX]);
    image(Image);
%    set(gca, 'visible', 'off');
    drawnow;
    Movie(:, idx-start+1) = getframe;
end
