%MFSIGMA0           Compute the mean value of sigma0 given a number of
%                   different measurement (assumed at different frequencies).
%
%    mMeanSigma0 = mfsigma0(mSigma0_1, mSigma0_2, mSigma0_3, mSigma0_4)
%
%    mMeanSigma0    Mean value of sigma 0. 
%
%    mSigma0_?      Independent samples of sigma 0 stored in the same strucure
%
%	    
%
%    Calls: 
%
%    Bugs:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mfsigma0.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   27 Oct 1993 11:17:16   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fnProc = [ 'MMtn4348_PCW13'
           'MMtn4350_PCW13'
           'MMtn4352_PCW13'
           'MMtn4354_PCW13'];

mMeanSigma0 = zeros(1651,37);
mAz = zeros(16, 37);

for index = 1:4,
    disp(['Loading ' fnProc(index,:) '...' ]);
    load(fnProc(index,:));

    mAz((index - 1) * 4 + [1:4], :)  = Azimuth(:,2:38);
    mMeanSigma0 = mMeanSigma0 + matSigma0(:,2:38);
end

mMeanSigma0 = mMeanSigma0 / 4;
vMeanAz = mean(mAz);
vStdAz = std(mAz);
if any(mStdAz) > 1,
    disp('High standard deviation on azimuth ...')
    mStd
end