%PLT_EG         Plot an electrogram(s) in multiline format. 
%
%   plt_eg
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:51 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: plt_eg.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:51  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plt_eg(eg1, sr1, eg2, sr2)

%%
%%  Parameters & initialization
%%
maxSampPerRow = 500;
maxRowsPerPage = 4;
gridon = 1;
clf
orient landscape

%%
%%  Create the time vector for the electrograms and compute the number of rows
%%
nSamples1 = length(eg1);
t1 = [0:nSamples1-1] ./ sr1;
nRows1 = ceil(nSamples1 / maxSampPerRow);
nPages1 = ceil(nRows1 / maxRowsPerPage);

if nargin > 2
else
    nRows = nRows1;
    nPages = nPages1
end

%%
%%  Loop over pages & rows creating the plots, execute a keyboard
%%
for iPage = 1:nPages
    subplot(nRows, 1, 1);
    for iRow = 1:nRows
        subplot(nRows, 1, iRow);
        idxStart = (iRow - 1) * maxSampPerRow + 1;

        %%
        %%  Make sure that the stop index is not greater than the signal length
        %%
        idxStop = idxStart + maxSampPerRow - 1;
        if idxStop > nSamples1
            idxStop = nSamples1;
        end
        
        plot(t1(idxStart:idxStop), eg1(idxStart:idxStop));
        grid on
        if iRow == floor(nRows/2)
            ylabel('Amplitude');
        end
        if iRow == nRows
            xlabel('Time')
        end
    end
    drawnow;
    if iPage ~= nPages
        pause;
    end
end

        
        