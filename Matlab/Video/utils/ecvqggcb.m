%ECVQGGCB        Generate mapping of codebook rates and files.
%
%   [Rates Files Lambda] = ecvqlacb;

function [Rates, Files, Lambda] = ecvqggcb


% Generate vector which holds the codebook rates
Rates = [
0.151466
0.172550
0.201463
0.229295
0.261964
0.300007
0.334009
0.378106
0.411272
0.457561
0.499613
0.543800
0.593582
0.631325
0.678764
0.713378
0.756106
0.781933
0.814171
0.849581
0.866649
0.943754
1.230163
1.521545
1.799979
2.035036
2.255270
2.447291
2.595145
2.823337
3.121949
3.364645
3.637505
3.834542
4.095960
4.331807
4.568874
4.771152
4.969566
5.164959
5.353700
5.507762
5.640778 ];

% Generate vector which holds codebook names
basepath = 'f:\data\video\codebook\ecvq\gengauss\';
Files =[
basepath 'gg8021.mat ';
basepath 'gg8020.mat ';
basepath 'gg8019.mat ';
basepath 'gg8018.mat ';
basepath 'gg8017.mat ';
basepath 'gg8016.mat ';
basepath 'gg8015.mat ';
basepath 'gg8014.mat ';
basepath 'gg8013.mat ';
basepath 'gg8012.mat ';
basepath 'gg8011.mat ';
basepath 'gg8010.mat ';
basepath 'gg8009.mat ';
basepath 'gg8008.mat ';
basepath 'gg8007.mat ';
basepath 'gg8006.mat ';
basepath 'gg8005.mat ';
basepath 'gg8004.mat ';
basepath 'gg8003.mat ';
basepath 'gg8002.mat ';
basepath 'gg8001.mat ';
basepath 'gg4007.mat ';
basepath 'gg4006.mat ';
basepath 'gg4005.mat ';
basepath 'gg4004.mat ';
basepath 'gg4003.mat ';
basepath 'gg4002.mat ';
basepath 'gg4001.mat ';
basepath 'gg4000.mat ';
basepath 'gg2a013.mat';
basepath 'gg2a012.mat';
basepath 'gg2a011.mat';
basepath 'gg2a010.mat';
basepath 'gg2a009.mat';
basepath 'gg2a008.mat';
basepath 'gg2a007.mat';
basepath 'gg2a006.mat';
basepath 'gg2a005.mat';
basepath 'gg2a004.mat';
basepath 'gg2a003.mat';
basepath 'gg2a002.mat';
basepath 'gg2a001.mat';
basepath 'gg2a000.mat'];

Lambda = [
1.250899
1.173396
1.100694
1.032497
0.968526
0.908518
0.852228
0.799425
0.749894
0.703432
0.659849
0.618966
0.580616
0.544642
0.510897
0.479243
0.449550
0.421696
0.395569
0.371060
0.348070
0.371060
0.269498
0.195734
0.142160
0.103250
0.074989
0.054464
0.039557
0.039557
0.028730
0.020866
0.015155
0.011007
0.007994
0.005806
0.004217
0.003063
0.002224
0.001616
0.001173
0.000852
0.000619 ];