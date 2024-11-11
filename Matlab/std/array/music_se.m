%MUSIC_SEQ	Estimate the AOA of a sequence of scenarios.
%
%    y = music_seq(mAOA, mSnrdB, nEl, nSamples, theta)
%
%    y		Output matrix of antenna array responses.
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
%    theta	The angles at which to compute the response (degrees).
%
%    Calls: getsnap, music

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:03 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: music_se.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:03  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = music_seq(mAOA, mSnrdB, nEl, nSamples, theta)

if ~all(size(mAOA) == size(mSnrdB)),
    error('The size of mAOA and mSnrdB must be equal');
end

[nScenarios nTargets] = size(mAOA);


for index = 1:nScenarios,
    x = getsnap(mAOA(index,:), mSnrdB(index,:), nEl, nSamples);

    y(:,index) = music(x, nTargets, theta);

end
