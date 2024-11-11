%I3DRECST       I3D record start
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:54 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: i3drecst.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.3  1997/04/21 13:13:49  rjg
%  Removed redundant end statement
%
%  Revision 1.2  1997/04/06 19:23:51  rjg
%  Added global declarations.
%  Installed movie recording section.
%
%  Revision 1.1  1996/09/20 04:45:58  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3drecst

global Data nRows nCols idxSample incrSample idxElem
global h3dFig h3dData h3dPoint flgFixZAxis
global nFrames Movie
global hMsg hEdit hRec

%%
%%  Delete the dialog box for starting recording
%%
delete(hMsg)
delete(hEdit)
delete(hRec)

%%
%%  Allocate space for the Movie
%%

figure(1)
Movie = moviein(nFrames, gcf);

%%
%%  Record movie
%%
for i = 1:nFrames,

    Array = reshape(Data(:, idxSample), nRows, nCols);
    %%
    %%  Update the image
    %%
    set(h3dPoint, 'ZData', Array(idxElem));
    set(h3dData, 'ZData', Array);
    set(h3dData, 'CData', Array);
    title(['Sample Index: ' int2str(idxSample)]);

    if ~flgFixZAxis,
        zMax = matmax(Array);
        zMin = matmin(Array);
        caxis([ zMin zMax]);
        colorbar(hColorBar);
    end

    %%
    %%  Record the image
    %%
    Movie(:,i) = getframe(gcf);
        idxSample = idxSample + incrSample;
end

i3drdraw;
