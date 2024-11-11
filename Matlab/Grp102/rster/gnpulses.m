%GNPULSES       Get the number of pulses for each from a RSTER Signal
%               Data Structure.
%
%    nPulses = gnpulses(strcRSDS)
%
%    nPulses    The number of pulses for each CPI.
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
%  $Log: gnpulses.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:37  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  nPulses = gnpulses(strcRSDS)
nPulses = strcRSDS(:,16);
