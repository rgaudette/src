%DET_SRCH       Find the largest region of a signal greater than a given value.
%
%    Range = det_srch(Signal, Threshold)
%
%    Range          The start and stop indicies of the largest region of
%                   Signal greater than threshold.
%
%    Signal         The signal to detect, if complex the absolute value of
%                   Signal is used.
%
%    Threshold      The detection threshold.
%
%	    
%        DET_SRCH first finds all elements of Signal greater than Threshold.
%    The regions are than analyzed to find the largest contiguous section
%    above Threshold.  The start and stop indicies of this region are returned
%    in Range.
%
%    Calls: none.
%
%    Bugs: not tested with matricies.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: det_srch.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:11:29  rjg
%  Initial revision
%
%  
%     Rev 1.3   29 Mar 1994 14:17:58   rjg
%  Forced signal to be a column vector within the function.  The correctly
%  handles signal as both a coumn and a row vector.
%  
%     Rev 1.2   22 Mar 1994 09:39:14   rjg
%  Updated help description.
%  
%     Rev 1.1   05 Jan 1994 13:56:04   rjg
%  Added the ability to correctly handle complex numbers.
%  
%     Rev 1.0   04 Jan 1994 16:08:34   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Range = det_srch(Signal, Threshold)

%%
%%    Make sure signal is a column vector
%%
Signal = Signal(:);

%%
%%    Is Signal or Threshold complex
%%
if any(imag(Signal)),
    Signal = abs(Signal);
end
if any(imag(Threshold)),
    Threshold = abs(Threshold);
end

%%
%%    Detect where signal crosses threshold, split into + and - crossings
%%
vDiff = diff(Signal > Threshold);

vPosCross = find(vDiff == 1);
vNegCross = find(vDiff == -1);

%%
%%    Compute sample count between + and - crossings, need to take into
%%    ends of signal.
%%

nSamp = length(Signal);

if Signal(1) <= Threshold,
    if Signal(nSamp) > Threshold,
	vNegCross =  [vNegCross; nSamp];
    end
else
    if Signal(nSamp) <= Threshold,
        vPosCross = [0; vPosCross];
    else
        vNegCross = [vNegCross; nSamp];
        vPosCross = [0; vPosCross];
    end
end

cntDetRegion = vNegCross - vPosCross;

%%
%%    Find the longest detect region
%%
[Length idxRegion] = max(cntDetRegion);

%%
%%    Extract the start and stop indicies of the reion
%%
Start = vPosCross(idxRegion) + 1;
Stop = vNegCross(idxRegion);
Range = [Start Stop];
