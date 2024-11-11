%GTXWFM         Get the transmitter waveform parameter from a RSTER Signal
%               Data Structure.
%
%    TxWfm  = gtxwfm(strcRSDS)
%
%    TxWfm      The transmitter waveform code for each CPI.
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
%  $Date: 2004/01/03 08:24:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: gtxwfm.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:38  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TxWfm = gtxwfm(strcRSDS)
TxWfm = strcRSDS(:,21);
