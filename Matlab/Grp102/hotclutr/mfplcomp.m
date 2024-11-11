%MFPLCOMP       Multiple frequency power level comparison.
%
%    result = mfplcomp(parm)
%
%    result	Output description.
%
%    parm	Input description.
%
%	    Describe function, it's methods and results.
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
%  $Log: mfplcomp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.0   09 Dec 1993 14:58:44   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fnBase = 'MMtn43';

fnMid = ['48'; '50'; '52'; '54'];

fnEnd = 'PCW13V';


for idxFile = 1:4,
    fnCurrFile = [fnBase fnMid(idxFile,:) fnEnd];

    disp(fnCurrFile);
    load(fnCurrFile);

    eval(['Azimuth' fnMid(idxFile,:) '=Azimuth;']);
    eval(['CWTRBeamformMF' fnMid(idxFile,:) '=CWTRBeamformMF;']);
    eval(['CWTRDipoleMF' fnMid(idxFile,:) '=CWTRDipoleMF;']);
    eval(['matBeamformMF' fnMid(idxFile,:) '=matBeamformMF;']);
    eval(['matDipoleMF' fnMid(idxFile,:) '=matDipoleMF;']);
    eval(['matNoiseFlr' fnMid(idxFile,:) '=matNoiseFlr;']);
    eval(['matRange' fnMid(idxFile,:) '=matRange;']);
    eval(['matSigma0' fnMid(idxFile,:) '=matSigma0;']);

end
