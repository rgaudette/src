%%PROC4354_200_240    Process 200 & 240 degree cuts for 435.4 MHz 13 uSec PCW
%%
%%    93.08.18: 435.4 MHz, Pulsed CW 13 uSec Vertical
%%
load apcal142
W = svrster(13, 0, 435/450, 3, 60);
MFC = fft(ones(13,1), 1651);
TxPos = -57330+j*34040;
strTitle = 'M Mtn 435.4 MHz';
strWfm ='13 uSec PCW';
fnCWTR = 'cwtr120v1';
fnNoise = '/radar/Noise/noise002v1';
fnSave = 'MMtn4354_200_240';
fnData = ['r2300935v1'
          'r2300940v1'
          'r2300948v1'
          'r2300973v1'
          'r2300974v1'
          'r2300975v1'
          'r2300976v1'
          'r2300977v1'];
