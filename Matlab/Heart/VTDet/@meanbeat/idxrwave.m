%IDXRWAVE       Exctract the R wave index from a MeanBeat object.
%
%   idxRwave = idxrwave(Meanbeat)
%
%   idxRwave    The index of the R wave in the mean beat.
%
%   MeanBeat    The MeanBeat object containing the mean beat sequence.
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:02 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: idxrwave.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:02  rickg
%  Matlab Source
%
%  Revision 1.1  1997/11/12 16:59:41  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function idx = idxrwave(obj);
idx = obj.idxRwave;
