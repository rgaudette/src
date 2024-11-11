%HCAZPATT           Basic function hcazpatt.
%
%    [IntRatio vAz] = hcazpatt(matBeamformMF, matRange, Azimuth, RangeStart)
%
%    IntRatio       Integrated power ratio
%
%    vAZ            The corresponding azimuths for IntRatio
%
%    matBeamformMF  Processed output for each azimuth (see hcg_s0.m).
%
%    matRange       The range from RSTER of each cell in matBeamformMF
%                   [meters].
%
%    Azimuth        The Azimuth matrix from hcg_s0.m
%
%    RangeStart     The distance from RSTER to start integrating the azimuth
%                   cuts, the direct path cut is integrated from 0 to the
%                   limit. 
%
%	    HCAZPATT produces and azimuth pattern by integrating the energy
%    received from a sequence of azimuth cuts.  This integrated energy is
%    compared to that received from the direct path (integrated from 0 to 
%    the integration limit).  This function requires that the processed
%    output be in the form output from mat_s0, that is the direct path signal
%    is in the first column, the next 37 contain the azimuth cuts.
%
%    Calls: none
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:30 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hcazpatt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:30  rickg
%  Matlab Source
%
%  
%     Rev 1.0   23 Sep 1993 11:27:10   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [IntRatio,vAz]= hcazpatt(matBeamformMF, matRange, Azimuth, RangeStart)

%%
%%    Constants
%%
WrapAroundLimit = 1300;

%%
%%    Correct last azimuth recording to match be either ~360 or ~0, which 
%%    ever is appropriate.
%%
vAz = Azimuth(1,[2:38]);
if mean(vAz) > 180 & vAz(37) < 180,
    vAz(37) = vAz(37) + 360;
end
if mean(vAz) < 180 & vAz(37) > 180,
    vAz(37) = vAz(37) - 360;
end

IntDirPath  = sum(v2p(matBeamformMF(1:WrapAroundLimit,1)));

indicies = find(matRange > RangeStart);

IntPower = zeros(size(matBeamformMF));

IntPower(indicies) = matBeamformMF(indicies);

IntRatio = sum(v2p(IntPower(1:WrapAroundLimit,[2:38]))).' / IntDirPath;

clf
plot(vAz, db(IntRatio));

xlabel('Azimuth (degrees)')
ylabel('Amplitude (dB)')
title(['Integrated Energy Relative To Direct Path   Ranges > ' ...
    num2str(RangeStart / 1000) ' km']);
grid
axis([180 360 -80 0])
