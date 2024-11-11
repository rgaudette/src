%GCPITIME       Get the CPI time parameter from a RSTER Signal Data Structure
%
%    CPITime= gcpitime(strcRSDS)
%
%    CPITime    The time of each CPI in MATLAB 6 element format.
%
%    strcRSDS   The RSTER Signal Data Strucutre.
%
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gcpitime.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CPITime = gcpitime(strcRSDS)
CPITime = strcRSDS(:,6:11);
