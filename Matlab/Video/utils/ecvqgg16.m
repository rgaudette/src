%ECVQGG16        Generate mapping of codebook rates and files.
%
%   [Rates Files Lambda] = ecvqgg16

function [Rates, Files, Lambda] = ecvqgg16


% Generate vector which holds the codebook rates
Rates = [
0.050377
0.059857
0.070257
0.080337
0.090074
0.099689 ]; 

% Generate vector which holds codebook names
basepath = '/usr/site/cdsp/scratch/hoag/Codebook/ECVQ/GG2/';
Files =[
basepath 'gg16b099.mat';
basepath 'gg16b078.mat';
basepath 'gg16b058.mat';
basepath 'gg16b040.mat';
basepath 'gg16b023.mat';
basepath 'gg16b007.mat'  ];

Lambda = [
2.231036
2.075607
1.937658
1.821361
1.717941
1.625975 ];