%LAPL_CB        Generate mapping of codebook rates and files.
%
%   [Rates Files] = cbfiles;

function [Rates, Files] = cbfiles


% Generate vector which holds the codebook rates
Rates = [
.0625
.125
.1875
.25
.3125
.375
.4375
.5
.5625
.625
.6666
.75
.875
1.0
1.125
1.25
1.5
1.75
2
2.25
2.5
3
3.5
4
4.5
5.000000
5.500000
6.000000
6.500000];

% Generate vector which holds codebook names
basepath = 'f:\data\video\codebook\laplace\';
Files =[
basepath 'VQ_2_16  ';
basepath 'VQ_4_16  ';
basepath 'VQ_8_16  ';
basepath 'VQ_16_16 ';
basepath 'VQ_32_16 ';
basepath 'VQ_64_16 ';
basepath 'VQ012816 ';
basepath 'VQ025616 ';
basepath 'VQ051216 ';
basepath 'VQ_32_8  ';
basepath 'VQ_4_3   ';
basepath 'VQ_64_8  ';
basepath 'VQ_128_8 ';
basepath 'VQ_256_8 ';
basepath 'VQ_512_8 ';
basepath 'VQ_32_4  ';
basepath 'VQ_64_4  ';
basepath 'VQ_128_4 ';
basepath 'VQ_256_4 ';
basepath 'VQ_512_4 ';
basepath 'VQ_32_2  ';
basepath 'VQ_64_2  ';
basepath 'VQ_128_2 ';
basepath 'VQ_256_2 ';
basepath 'VQ_512_2 ';
basepath 'VQ_1024_2';
basepath 'VQ_2048_2';
basepath 'VQ_4096_2';
basepath 'VQ_8192_2'];
