%PROC_SOC4354_13V   Process all azimuth angles for Socorro Peak 435.4 MHz
%                   13 uSec PCW Vertical.
%
%    93.08.18: 435.4 MHz, Pulsed CW 13 uSec Vertical
%

%load apcal142
W = svrster(13, 0, 435/450, 3, 60);
MFC = fft(ones(13,1), 1651);
TxPos = -57330+j*34040;
TxPow = 47.32;
strTitle = 'M Mtn 435.4 MHz';
strWfm = '13 uSec PCW';
fnCWTR = 'cwtr120v1';
fnNoise = '/radar/Noise/noise002v1';
fnSave = 'MMtn4354PCW13V'
fnData = [  'r2300935v1'
            'r2300936v1'
            'r2300937v1'
            'r2300938v1'
            'r2300939v1'
            'r2300940v1'
            'r2300941v1'
            'r2300942v1'
            'r2300943v1'
            'r2300944v1'
            'r2300945v1'
            'r2300946v1'
            'r2300947v1'
            'r2300948v1'
            'r2300949v1'
            'r2300950v1'
            'r2300951v1'
            'r2300952v1'
            'r2300953v1'
            'r2300954v1'
            'r2300955v1'
            'r2300956v1'
            'r2300957v1'
            'r2300958v1'
            'r2300959v1'
            'r2300960v1'
            'r2300961v1'
            'r2300962v1'
            'r2300963v1'
            'r2300964v1'
            'r2300965v1'
            'r2300966v1'
            'r2300967v1'
            'r2300968v1'
            'r2300969v1'
            'r2300970v1'
            'r2300971v1'
            'r2300972v1'
            'r2300973v1'
            'r2300974v1'
            'r2300975v1'
            'r2300976v1'];


