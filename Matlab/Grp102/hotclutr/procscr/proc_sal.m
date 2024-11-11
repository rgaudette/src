%PROC_SAL4352_13V   Process all azimuth cuts from Salinas Peak
%                   435.2 13 uSec PCW Vertical
%
%    93.07.21: Salinas Peak 435.2 MHz, Pulsed CW 13 uSec Vertical
%

W = svrster(13, 0, 435/450, 3, 60);
MFC = fft(ones(13,1), 1651);
TxPos = -15600-j*49680;
TxPow = 47.40;
strTitle = 'Salinas Peak 435.2 MHz';
strWfm = '13 uSec PCW';
fnCWTR = 'cwtr104v1';
fnNoise = '/radar/Noise/noise002v1';
fnSave = 'Sal4352PCW13V';
fnData = ['r2021332v1'
          'r2021333v1'
          'r2021334v1'
          'r2021335v1'
          'r2021336v1'
          'r2021337v1'
          'r2021338v1'
          'r2021339v1'
          'r2021340v1'
          'r2021341v1'
          'r2021342v1'
          'r2021343v1'
          'r2021344v1'
          'r2021345v1'
          'r2021346v1'
          'r2021347v1'
          'r2021348v1'
          'r2021349v1'
          'r2021350v1'
          'r2021351v1'
          'r2021352v1'
          'r2021353v1'
          'r2021354v1'
          'r2021355v1'
          'r2021356v1'
          'r2021357v1'
          'r2021358v1'
          'r2021359v1'
          'r2021360v1'
          'r2021361v1'
          'r2021362v1'
          'r2021363v1'
          'r2021364v1'
          'r2021365v1'
          'r2021366v1'
          'r2021367v1'
          'r2021368v1'
          'r2021369v1'
          'r2021370v1' ];
