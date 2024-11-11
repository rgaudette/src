%CBFILES        Generate mapping of codebook rates and files.
%
%   [Rates Files] = gen_vq_cdbk;

function [Rates, Files] = gen_vq_cdbk


% Generate vector which holds the codebook rates
Rates = [
.25
.33333
.5
.66666
.75
1.0
1.25
1.3333
1.5
1.6666
1.75
2
2.25
2.5
2.6666
3.0
3.5
4.0
4.5
5.000000
6.000000]; 

% Generate vector which holds codebook names
basepath = 'f:\data\video\codebook\gengauss\';
Files =[
basepath 'GG000408';
basepath 'GG000406';
basepath 'GG001608';
basepath 'GG001606';
basepath 'GG006408';
basepath 'GG025608';
basepath 'GG003204';
basepath 'GG025606';
basepath 'GG006404';
basepath 'GG003203';
basepath 'GG012804';
basepath 'GG025604';
basepath 'GG051204';
basepath 'GG003202';
basepath 'GG025603';
basepath 'GG006402';
basepath 'GG012802';
basepath 'GG025602';
basepath 'GG051202';
basepath 'GG102402';
basepath 'GG409602'];
