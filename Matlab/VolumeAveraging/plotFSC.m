%plotFSC        Plot the Fourier Shell Correlation results
%
%   plotFSC(fnFSC_out)
%
%   fnFSC_out   The filename of the Fourier shell correlation results
%
%
%   plotFSC reads in the Fourier shell correlation results file from calcFSC
%   and displays the FSC curve for each instance in the file.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/24 22:02:32 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotFSC(fnFSC_out)

% Load in the FSC data
load(fnFSC_out)

% voxel size in nm
voxel = szVoxel / 10;

clf
plhLines = spPlot(freqShells ./ voxel, arrFSCC, 1);
hXL = xlabel('Resolution (nm)');
hYL = ylabel('Fourier Shell Correlation ');
hT = title([fnVolume ': ' fnAlign]);
set(hT, 'Interpreter', 'none');

% Adjust the fonts, tick spacing and axis
mkltbig(2);
setfontsize(14)
set(gca, 'YTick', [0:0.1:1])
axis([2/voxel 10 0 1])

% Show a generic legend
for i = 1:length(nParticles)
  cLegend{i} = sprintf('n = %d', nParticles(i));
end
hLegend = legend(cLegend);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: plotFSC.m,v $
%  Revision 1.1  2005/10/24 22:02:32  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
