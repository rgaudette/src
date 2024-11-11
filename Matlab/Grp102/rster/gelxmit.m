%GELXMIT        Get the transmit elevation  parameter from a RSTER Signal
%               Data Structure.
%
%    gelxmit = gelxmit(strcRSDS)
%
%    ElXmit     The transmit elevation parameter.
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
%  $Log: gelxmit.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ElXmit = gelxmit(strcRSDS)
ElXmit = strcRSDS(:,13);
