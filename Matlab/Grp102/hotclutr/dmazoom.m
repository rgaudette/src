%DMAZOOM	Zoom in on a DMA elevation map, optionally plotting a contour,
%		mesh or surface plot of the zoomed area.
%
%    [zdma, zxdist, zydist] = dmazoom(xdist, ydist, dma, axis, flgPlot)
%
%    zdma	The zoomed portion of the DMA map.
%
%    zxdist	The x distance vector corresponding to the zoomed map.
%
%    zydist	The y distance vector corresponding to the zoomed map.
%
%    xdist	The input DMA matrix x distance vector.
%
%    ydist	The input DMA matrix y distance vector.
%
%    dma	The input DMA matrix.
%
%    axis	The area to zoomed in on, [xmin xmax ymin ymax].
%
%    flgPlot	How if at all to display the zoomed data.
%		    0	No plot
%		    1	Contour map, with selectable labels.
%		    2	Mesh plot.
%		    3	Surface plot.
%
%    Calls: 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: dmazoom.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.0   03 Aug 1993 23:37:54   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zdma, zxdist, zydist] = dmazoom(xdist, ydist, dma, zaxis, flgPlot)

xsel = find(zaxis(1) <= xdist & zaxis(2) >= xdist);
ysel = find(zaxis(3) <= ydist & zaxis(4) >= ydist);

zxdist = xdist(xsel);
zydist = ydist(ysel);
zdma = dma(ysel, xsel);

if flgPlot == 1,
    cs = contour(zxdist, zydist, zdma, [0:50: max(max(zdma))]);
    if ~ishold,
	axis(zaxis);
    end
    clabel(cs, 'manual');
end

if flgPlot == 2,
    mesh(zxdist, zydist, zdma);
    if ~ishold,
	axis([zaxis min(min(zdma)) max(max(zdma))]);
    end   
end

if flgPlot == 3,
    surf(zxdist, zydist, zdma);
    if ~ishold,
	axis([zaxis min(min(zdma)) max(max(zdma))]);
    end   
end

