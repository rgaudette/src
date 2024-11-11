function x = aoa_seq(mAOA, mSnrdB, nEl)
%AOA_SEQ	Generate an Angle of Arrival sequence for a linear array.
%
%    x = aoa_seq(mAOA, snrdb, nEl)
%
%    x		Output matrix of the array, 
%
%    mAOA	Angle of Arrival matrix, each row is a unique AOA scenario
%		each column represents the AOA of a single target.  The size
%		of mAOA and mSnrdB must be identical.
%
%    mSnrdB	Signal to noise ratio matrix (in dB).  Each element of this 
%		matrix specifies the SNR of the corresponding target in mAOA.
%		Thus, the size of mAOA and mSnrdB must be identical.
%
%    nEl	The number of elements in the antenna array.
%
%	This function generates a series of linear antenna array responses
%    for the angle of arrival scenarios presented in the columns of mAOA and
%    mSnrdB.  An array output of length nEl is generated for each scenario.
%    This function is essential a wrapper to make repeated calls to getsnap.
%
%    Calls: getsnap

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:36 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: aoa_seq.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:36  rickg
%  Matlab Source
%
%  
%     Rev 1.0   22 Feb 1993 14:07:56   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~all(size(mAOA) == size(mSnrdB)),
    error('The size of mAOA and mSnrdB must be equal');
end

[nScenarios nTargets] = size(mAOA);

for index = 1:nScenarios,
    x(:,index) = getsnap(mAOA(index,:), mSnrdB(index,:), nEl, 1);
end

return
