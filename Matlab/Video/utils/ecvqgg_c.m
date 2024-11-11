%ECVQGG_B        Generate mapping of codebook rates and files.
%
%   [Rates Files Lambda] = ecvqgg_b

function [Rates, Files, Lambda] = ecvqgg_b


% Generate vector which holds the codebook rates
Rates = [
0.180399
0.203235
0.225535
0.247700
0.399923
0.577526
0.780475
1.018186
1.271108
1.527648
1.789206
2.057586
2.286726
2.510216
2.823337
3.121949
3.364645
3.637505
3.834542
4.095960
4.331807
4.568874
4.771152
5.764383
5.973843
6.196132
6.416737
6.624097
 ];

% Generate vector which holds codebook names
basepath = '/usr/site/cdsp/scratch/hoag/Codebook/ECVQ/GG2/';
Files =[
basepath 'gg8b021.mat ';
basepath 'gg8b020.mat ';
basepath 'gg8b019.mat ';
basepath 'gg4b010.mat ';
basepath 'gg4b009.mat ';
basepath 'gg4b008.mat ';
basepath 'gg4b007.mat ';
basepath 'gg4b006.mat ';
basepath 'gg4b005.mat ';
basepath 'gg4b004.mat ';
basepath 'gg4b003.mat ';
basepath 'gg4b002.mat ';
basepath 'gg4b001.mat ';
basepath 'gg4b000.mat ';
basepath 'gg2a013.mat ';
basepath 'gg2a012.mat ';
basepath 'gg2a011.mat ';
basepath 'gg2a010.mat ';
basepath 'gg2a009.mat ';
basepath 'gg2a008.mat ';
basepath 'gg2a007.mat ';
basepath 'gg2a006.mat ';
basepath 'gg2a005.mat ';
basepath 'gg2b008.mat ';
basepath 'gg2b007.mat ';
basepath 'gg2b006.mat ';
basepath 'gg2b005.mat ';
basepath 'gg2b004.mat ' ];

Lambda = [
1.250899
1.173396
1.100694
0.968526
0.703432
0.510897
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
0.000619
0.000450
0.000327
0.000237
0.000172 ];
