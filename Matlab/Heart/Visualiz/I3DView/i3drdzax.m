%I3DRDZAX        I3D z-axis reader
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
%  $Log: i3drdzax.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:54  rickg
%  Matlab Source
%
%  Revision 1.1  1996/09/20 04:45:29  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i3drdzax
global flgFixZAxis
global xMin xMax yMin yMax zMin zMax
global hEdit hMsg

%%
%%  Read in the new z axis value
%%
vecZAxis = eval(get(hEdit, 'String'));
if length(vecZAxis) < 2,
    flgFixZAxis = 0;
    figure(1)
else
    flgFixZAxis = 1;
    zMin = vecZAxis(1);
    zMax = vecZAxis(2);
    figure(2)
    Axis2 = axis;
    axis([Axis2(1) Axis2(2) zMin zMax])
    figure(1)
    caxis([zMin zMax])
    colorbar
end
CurrAxis = axis;
if length(CurrAxis) > 4,
    axis([xMin xMax yMin yMax zMin zMax])
end

figure(3)

%%
%%  Delete the dialog box.
%%
delete(hMsg);
delete(hEdit);