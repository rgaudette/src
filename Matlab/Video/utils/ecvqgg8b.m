%ECVQGG8B        Generate mapping of codebook rates and files.
%
%   [Rates Files Lambda] = ecvqgg8b

function [Rates, Files, Lambda] = ecvqgg8b


% Generate vector which holds the codebook rates
Rates = [
0.180399
0.203235
0.225535
0.249953
0.276075
0.303729
0.328349
0.363904
0.393031
0.425500
0.457487
0.490294
0.524929
0.560922
0.599338
0.635681
0.675492
0.712871
0.747319
0.778976
0.805590
0.833451 ]; 

% Generate vector which holds codebook names
basepath = '/usr/site/cdsp/scratch/hoag/Codebook/ECVQ/GG2/';
Files =[
basepath 'gg8b021.mat';
basepath 'gg8b020.mat';
basepath 'gg8b019.mat';
basepath 'gg8b018.mat';
basepath 'gg8b017.mat';
basepath 'gg8b016.mat';
basepath 'gg8b015.mat';
basepath 'gg8b014.mat';
basepath 'gg8b013.mat';
basepath 'gg8b012.mat';
basepath 'gg8b011.mat';
basepath 'gg8b010.mat';
basepath 'gg8b009.mat';
basepath 'gg8b008.mat';
basepath 'gg8b007.mat';
basepath 'gg8b006.mat';
basepath 'gg8b005.mat';
basepath 'gg8b004.mat';
basepath 'gg8b003.mat';
basepath 'gg8b002.mat';
basepath 'gg8b001.mat';
basepath 'gg8b000.mat' ];


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
0.326504 ];