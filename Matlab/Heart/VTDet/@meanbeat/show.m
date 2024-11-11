%SHOW           Display the contents of a MeanBeat object
%
%   show(MeanBeat)
%
%   MeanBeat    The MeanBeat object to display.
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
%  $Log: show.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:02  rickg
%  Matlab Source
%
%  Revision 1.1  1997/11/12 16:54:09  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function show(obj)
fprintf('Number of beats:\t\t%d\n', obj.nBeats);
fprintf('Next beat index:\t\t%d\n', obj.NextBeat);
fprintf('QRS search width:\t\t%f\n', obj.wdQRS);
fprintf('Saved beat width:\t\t%f\n', obj.wdBeat);
fprintf('Saved beat samples:\t\t%d\n', length(obj.Beat));
fprintf('R wave index:\t\t\t%d\n', obj.idxRwave);
fprintf('Sampling Rate:\t\t\t%f\n', obj.FSamp);
fprintf('Amplitude units:\t\t%s\n', obj.Units);
fprintf('Minimum CC:\t\t\t%f\n', obj.MinCC);
fprintf('Minimum R-to-R period (sa):\t%d\n', obj.MinRtoR);


