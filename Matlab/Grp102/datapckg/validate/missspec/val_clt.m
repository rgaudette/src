%VAL_CLUT           Validate clutter data collection clut01

%%
%%    Initialization
nChan = 14;
Elevation = 0;
FCenter = 450e6;
FData = 435e6;
tPulse = 80e-6;
bwPulse = 500e3;
nMFC = 92;

ChebWin = 3;
ElevSLL = 30;
DopWinSLL = 70;

SimFlag = 0;

%%
%%    Load the physical constants file.
%%
phys_con;

%%
%%    Beamformer coefficients
%%
W = svrster(nChan, Elevation, FData / FCenter, ChebWin, ElevSLL);

%%
%%    Matched filter coefficients
%%
hPC = ifft(gethpc(1, tPulse, bwPulse, nMFC, SimFlag));

for pass = 12:14,
    for scan = 1:9,

	%%
	%%    Load in the data file
	%%
	fnData = ['tow' int2str(pass) 'v' int2str(scan) '.mat'];
	if exist(fnData) == 2,
            disp(['Loading: ' fnData]);
            load(fnData)

            %%
            %%    Loop over each CPI
            %%
            nCPI = length(npulses);
            for cpi = 1:nCPI,

                %%
                %%    Produce a Clutter Cancelled RD map for CPI
                %%
                CPI = eval(['cpi' int2str(cpi)]);
                rdmap = bfmtidoprng(CPI, npulses(cpi), W, hPC, DopWinSLL);

                Range = [trecord:trecord+wrecord-nMFC]* 1e-6 / 2 * C * m2nmi;
		clf
                contour(Range, [0:14], db(v2p(rdmap)), [60:3:100]);
                grid

                xlabel('Range (NMi)');
                ylabel('MTI Doppler Bin')

                title([fnData ': CPI #' int2str(cpi) ', Azimuth: ' ...
                    num2str(azxmit(cpi)) ' 3dB contours, Floor = 60']);
                drawnow;
            end
        end
    end
end
