%VPLT_CNT       Create a labeled contour plot
%
%    vplt_cnt(vX, vY, Axis, XLabel, YLabel, Title)
%
%
%    parm       Input description [units: MKS].
%
%    Optional   OPTIONAL: This parameter is optional (default: value).
%
%
%    Calls: tag
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: vplt_cnt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:27  rickg
%  Matlab Source
%
%  
%     Rev 1.0   02 May 1994 20:21:08   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vplt_cnt(vX, vY, mZ, cLines, Axis, XLabel, YLabel, Title)

%%
%%    Plot curve
%%
contour(vX, vY, mZ, cLines);

%%
%%    Set axis
%%
axis(Axis);

grid

xlabel(XLabel);
ylabel(YLabel);
title(Title);

%%
%%    Resize and date plot
%%
tag('');
