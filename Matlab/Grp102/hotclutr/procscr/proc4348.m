%%PROC4348_200_240    Process 200 & 240 degree cuts for 434.8 MHz 13 uSec PCW
%%
%%
%%
load apcal136
W = svrster(13, 0, 435/450, 3, 60);
MFC = fft(ones(13,1), 1651);
TxPos = -57330+j*34040;
fnCWTR = 'cwtr117v1';
fnNoise = '/radar/Noise/noise002v1';
strTitle = 'M Mtn 434.8 MHz';
strWfm = '13 uSec PCW';
fnSave = 'MMtn4348_200_240';
fnData = ['r2281325v1'
          'r2281330v1'
          'r2281339v1'
          'r2281364v1'
          'r2281365v1'
          'r2281366v1'
          'r2281367v1'
          'r2281368v1'];
