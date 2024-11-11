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
%  $Date: 2004/01/03 08:24:35 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mfsigma0.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:35  rickg
%  Matlab Source
%
%  
%     Rev 1.0   27 Oct 1993 11:17:16   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%fnProc = [ 'MMtn4348PCW13V'; 'MMtn4350PCW13V';
%           'MMtn4352PCW13V'; 'MMtn4354PCW13V'];

%fnProc = [ 'MMtn4348PCW13H'; 'MMtn4350PCW13H';
%           'MMtn4352PCW13H'; 'MMtn4354PCW13H'];

fnProc = [ 'Sal4348PCW13V'; 'Sal4350PCW13V';
           'Sal4352PCW13V'; 'Sal4354PCW13V'];

ProcAz = [90:5:270];

mMeanSigma0 = zeros(1651,length(ProcAz));
mAz = zeros(16, length(ProcAz));
DataCount = zeros(1,length(ProcAz));

for index = 1:4,
    disp(['Loading ' fnProc(index,:) '...' ]);
    load(fnProc(index,:));

    vAz = mean(Azimuth);

    idxProcAz = 1;
    for CurrAz = ProcAz,
        %%
        %%    Find indicies that match current azimuth.
        %%
        idxData = find(vAz > CurrAz - 2.5 & vAz < CurrAz + 2.5);

        if ~isempty(idxData),
            disp(['    Processing azimuth: ' num2str(CurrAz)]);

            idxData = idxData(1);

            mMeanSigma0(:,idxProcAz) = mMeanSigma0(:,idxProcAz) + ...
                matSigma0(:,idxData);

            DataCount(idxProcAz) = DataCount(idxProcAz) + 1;

            mAz((index - 1) * 4 + [1:4], idxProcAz)  = Azimuth(:,idxData);

        else
            disp(['    Azimuth not found: ' num2str(CurrAz)]);
        end
        idxProcAz = idxProcAz + 1;
    end
end

mMeanSigma0 = mMeanSigma0 ./ (ones(1651,1) * DataCount);
vMeanAz = mean(mAz);
vStdAz = std(mAz);
if any(vStdAz) > 1,
    disp('High standard deviation on azimuth ...')
    vStdAz
end