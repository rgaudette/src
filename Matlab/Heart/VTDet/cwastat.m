%CWASTAT        Compute the CWA for a group of data files
Patients = ['barnsr'
            'donnsr'
            'kawksr'
            'silvsr'
            'thursr'
            'bongsr'
            'fichsr'
            'lloysr'
            'simosr'
            'wrobsr'
            'coopsr'
            'fitzsr'
            'lottsr'
            'sullsr'
            'dearsr'
            'gardsr'
            'parssr'
            'tesssr'];


%%
%%  Loop over the patients computing the cross - correlation stats
%%
[nPatients nChars] = size(Patients);

for iPat = 1:nPatients

    CurrPat = eval(Patients(iPat, :));

    %%
    %%  Compute a mean NSR beat
    %%
    mbNSR = meanbeat(mkegstrct(CurrPat));

    %%
    %%  Compute the NSR stats
    %%
    disp(['Data file: ' Patients(iPat, :)])
    [matCC PeakCC ShiftPeakCC] = vtccstat(beat(mbNSR), CurrPat);
    disp('Peak CCs');
    PeakCC
    disp('Peak CC Shift')
    ShiftPeakCC
    disp('Mean Peak CC')
    meanPeakCC = mean(PeakCC);
    meanPeakCC
    
    
    %%
    %%  Compute the VT stats
    %%
    VTpat = eval([Patients(iPat, 1:4) 'vt']);
    disp(['Data file: ' Patients(iPat, 1:4) 'vt'])
    disp('mean PeakCC std PeakCC')
    [stats cc ] = vtccstat(beat(mbNSR), VTpat);
end


