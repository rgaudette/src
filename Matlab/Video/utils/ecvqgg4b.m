%ECVQGG4B        Generate mapping of codebook rates and files.
%
%   [Rates Files Lambda] = ecvqgg4b

function [Rates, Files, Lambda] = ecvqgg4b


% Generate vector which holds the codebook rates
Rates = [
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
2.510216 ]; 

% Generate vector which holds codebook names
basepath = '/usr/site/cdsp/scratch/hoag/Codebook/ECVQ/GG2/';
Files =[
basepath 'gg4b010.mat';
basepath 'gg4b009.mat';
basepath 'gg4b008.mat';
basepath 'gg4b007.mat';
basepath 'gg4b006.mat';
basepath 'gg4b005.mat';
basepath 'gg4b004.mat';
basepath 'gg4b003.mat';
basepath 'gg4b002.mat';
basepath 'gg4b001.mat';
basepath 'gg4b000.mat' ];


Lambda = [
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
0.039557 ];
