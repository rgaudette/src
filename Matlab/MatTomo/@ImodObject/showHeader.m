%showHeader     Display the ImodObject header
%
%   showHeader(imodObject)
%
%   imodObject  The ImodObject
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 05:03:27 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showHeader(imodObject, preString)

if nargin < 2
  preString = '';
end

fprintf('%sName: "%s"\n', preString, imodObject.name);
fprintf('%scontours: %d\n', preString, imodObject.nContours);
fprintf('%sflags: %d\n', preString, imodObject.flags);
fprintf('%saxis: %d\n', preString, imodObject.axis);
fprintf('%sdrawmode: %d\n', preString, imodObject.drawMode);
fprintf('%sred: %f\n', preString, imodObject.red);
fprintf('%sgreen: %f\n', preString, imodObject.green);
fprintf('%sblue: %f\n', preString, imodObject.blue);
fprintf('%spdrawsize: %d\n', preString, imodObject.pdrawsize);
fprintf('%ssymbol: %d\n', preString, imodObject.symbol);
fprintf('%ssymsize: %d\n', preString, imodObject.symbolSize);
fprintf('%slinewidth2: %d\n', preString, imodObject.lineWidth2D);
fprintf('%slinewidth: %d\n', preString, imodObject.lineWidth3D);
fprintf('%slinesty: %d\n', preString, imodObject.lineStyle);
fprintf('%ssymflags: %d\n', preString, imodObject.symbolFlags);
fprintf('%ssympad: %d\n', preString, imodObject.sympad);
fprintf('%strans: %d\n', preString, imodObject.transparency);
fprintf('%smeshsize: %d\n', preString, imodObject.nMeshes);
fprintf('%ssurfsize: %d\n', preString, imodObject.nSurfaces);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: showHeader.m,v $
%  Revision 1.2  2005/05/09 05:03:27  rickg
%  Comment update
%
%  Revision 1.1  2004/09/18 20:36:49  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
