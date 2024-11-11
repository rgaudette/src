%GETRDMAP	Basic function getrdmap.
%
%    FileName = getrdmap(Azimuth)
%
%    FileName   String containing the name of the rdmap file.
%
%    Azimuth	The azimuth angle of the needed file.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:30 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: getrdmap.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:30  rickg
%  Matlab Source
%
%  
%     Rev 1.0   13 Sep 1993 17:27:10   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FileName] = getrdmap(Azimuth)

Base = 'rdmap';

az_order = [ 308 298 303 355:-5:180];

FileNum = [6:15 17:45];

index = find(az_order > Azimuth - 1 & az_order < Azimuth + 1);

FileName = [Base sprintf('%02.0f', FileNum(index))];
