%%PROC4352_200_240    Process 200 & 240 degree cuts for 435.2 MHz 13 uSec PCW
%%
%%    93.08.18: 435.2 MHz, Pulsed CW 13 uSec Vertical
%%
load apcal140
W = svrster(13, 0, 435/450, 3, 60);
MFC = fft(ones(13,1), 1651);
TxPos = -57330+j*34040;
strTitle = 'M Mtn 435.2 MHz';
strWfm = '13 uSec PCW';
fnCWTR = 'cwtr119v1';
fnNoise = '/radar/Noise/noise002v1';
fnSave = 'MMtn4352_200_240';
fnData = ['r2300818v1'
          'r2300823v1'
          'r2300831v1'
          'r2300856v1'
          'r2300857v1'
          'r2300858v1'
          'r2300859v1'
          'r2300860v1'];
