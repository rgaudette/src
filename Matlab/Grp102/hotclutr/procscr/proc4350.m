%%PROC4350_200_240    Process 200 & 240 degree cuts for 435.0 MHz 13 uSec PCW
%%
%%    93.08.16: 435.0 MHz, Pulsed CW 13 uSec Vertical
%%
load apcal134
W = svrster(13, 0, 435/450, 3, 60);
MFC = fft(ones(13,1), 1651);
TxPos = -57330+j*34040;
strTitle = 'M Mtn 435.0 MHz';
strWfm = '13 uSec PCW';
fnCWTR = 'cwtr116v1';
fnNoise = '/radar/Noise/noise002v1';
fnSave = 'MMtn4350_200_240';
fnData = ['r2281222v1'
          'r2281227v1'
          'r2281235v1'
          'r2281260v1'
          'r2281261v1'
          'r2281262v1'
          'r2281263v1'
          'r2281264v1'];
