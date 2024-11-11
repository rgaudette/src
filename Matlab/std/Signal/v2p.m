%V2P            Convert a voltage to power.
%
%    power = v2p(voltage)
%
%    power      The output power sequence.
%
%    voltage    The input voltage sequence.
%
%
%	    This function implements the formula,
%
%    power = real(voltage .* conj(voltage))
%
%    Calls: none
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:20 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: v2p.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:03:20  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function power = v2p(voltage)
power = real(voltage .* conj(voltage));
