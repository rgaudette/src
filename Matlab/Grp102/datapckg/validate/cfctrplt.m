%CFCTRPLT           Plot the calibration factors.
%
%    cfctrplt(apcal, fcal, heq, MissDesc, PrintFile);
%
%    apcal          The amplitude and phase calibration coefficients.
%
%    fcal           The frequency corresponding to each column of apcal.
%
%    heq            The equalization coefficients.
%
%    MissDesc       A mission description for the plot title.
%
%    PrintFile      OPTIONAL: The basename of the output plots, the amplitude
%                   and phase coefficient plot has a '_apcoef.ps' extension
%                   the equalization coefficient plots have a '_eqlo.ps' and
%                   '_eqhi.ps' extension.  If this parameter is not supplied
%                   then the plots are sent to the printer.
%	    
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:26 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cfctrplt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:26  rickg
%  Matlab Source
%
%  
%     Rev 1.2   03 May 1994 11:09:32   rjg
%  EPS file output changed to color.
%  
%     Rev 1.1   11 Feb 1994 17:02:54   rjg
%  Added option to print EPS to a file.
%  
%     Rev 1.0   09 Feb 1994 18:19:26   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cfctrplt(apcal, fcal, heq, MissDesc, PrintFile)

flgPrintFile = 0;
%%
if nargin > 4,
    flgPrintFile = 1;
end

%%
%%    Plot amplitude and phase calibration coefficients for each frequency
%%    available

%%
%%    Clear figure window
%%
clf

fcal = fcal(:).';

index = 1;
for Freq = fcal
    subplot(2,1,1);

    %%
    %%    Bring top plot down page a little so that a three ring will not 
    %%    puntcure the title
    %%
    pos = get(gca, 'position');
    pos(2) = pos(2) - 0.06;
    set(gca, 'position', pos);

    plot(db(v2p(apcal(:,index))));
    axis([1 14 -3 3]);
    grid
    title(['A&P Cal Coeff.  Freq:' num2str(Freq / 1e6) ' MHz  ' MissDesc ]);

    xlabel('Channel')
    ylabel('Amplitude (dB)')

    subplot(2,1,2);
    plot(angle(apcal(:,index))*180/pi);
    axis([1 14 -45 45]);
    grid;
    xlabel('Channel');
    ylabel('Phase (Degrees)');

    if flgPrintFile,
        print('-depsc', [PrintFile '_apcoef']);
    else
        print
    end

    index = index + 1;
end


%%
%%    Plot amplitude of equalization coefficients for channels 1 - 7
%%
clf

for iplot = 1:7,
    channel = iplot;
    subplot(7,1,iplot);

    %%
    %%
    plot(db(v2p(heq(:, channel))));
    axis([1 31 -40 0])
    grid


    if iplot == 7,
        xlabel('Index');
    else
        set(gca, 'XTickLabels', '');
    end

    if iplot == 4,
	ylabel('Amplitude (dB)');
    end
    if iplot == 1,
        title(['Equalization Coefficients  ' MissDesc]);
    else
        title(['Channel: ' int2str(channel)]);
    end
end
if flgPrintFile,
    print('-depsc', [PrintFile '_eqlo']);
else
    print
end

%%
%%    Plot amplitude of equalization coefficients for channels 8 - 14
%%
clf

for iplot = 1:7,
    channel = iplot + 7;
    subplot(7,1,iplot);

    %%
    %%
    plot(db(v2p(heq(:, channel))));
    axis([1 31 -40 0])
    grid


    if iplot == 7,
        xlabel('Index');
    else
        set(gca, 'XTickLabels', '');
    end

    if iplot == 4,
	ylabel('Amplitude (dB)');
    end
    if iplot == 1,
        title(['Equalization Coefficients  ' MissDesc]);
    else
        title(['Channel: ' int2str(channel)]);
    end
end
if flgPrintFile,
    print('-depsc', [PrintFile '_eqhi']);
else
    print
end
