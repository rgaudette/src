%ECVQLACB        Generate mapping of codebook rates and files.
%
%   [Rates Files Lambda] = ecvqlacb;

function [Rates, Files, Lambda] = ecvqlacb


% Generate vector which holds the codebook rates
Rates = [
0.029567
0.032056
0.035863
0.039804
0.044659
0.049134
0.053701
0.059946
0.067457
0.075209
0.083488
0.093499
0.104785
0.117057
0.131531
0.149521
0.164570
0.179827
0.198950
0.222503
0.250514
0.280560
0.308425
0.343922
0.380769
0.421389
0.469020
0.518416
0.578999
0.645689
0.713959
0.789365
0.863669
0.931203
0.991643
1.050864
1.122586
1.278901
1.474622
1.706840
2.008299
2.236888
2.324332
2.370263
2.429414
2.476442
2.519245
2.614430
2.744374
2.831061
2.964227
3.113331
3.161308
3.372059
3.598050
3.906708
3.928961
3.961130
3.963451
3.998984
4.025556
4.062738
4.073944
4.092857
4.112347
4.142502
4.173396
4.189111
4.214253
4.235987
4.265881
4.314943
4.337000
4.374876
4.431080
4.444202
4.477758
4.518595
4.546833
4.592597
4.626569
4.658871
4.730019
4.781064
4.827663
4.891553
4.954861
5.046742
5.112462
5.223825
5.310545
5.423422
5.555292
5.806312
6.074080
6.463983 ];

% Generate vector which holds codebook names
basepath = 'f:\data\video\codebook\ecvq\laplace\';
Files =[
basepath 'la8b039';
basepath 'la8b038';
basepath 'la8b037';
basepath 'la8b036';
basepath 'la8b035';
basepath 'la8b034';
basepath 'la8b033';
basepath 'la8b032';
basepath 'la8b031';
basepath 'la8b030';
basepath 'la8b029';
basepath 'la8b028';
basepath 'la8b027';
basepath 'la8b026';
basepath 'la8b025';
basepath 'la8b024';
basepath 'la8b023';
basepath 'la8b022';
basepath 'la8b021';
basepath 'la8b020';
basepath 'la8b019';
basepath 'la8b018';
basepath 'la8b017';
basepath 'la8b016';
basepath 'la8b015';
basepath 'la8b014';
basepath 'la8b013';
basepath 'la8b012';
basepath 'la8b011';
basepath 'la8b010';
basepath 'la8b009';
basepath 'la8b008';
basepath 'la8b007';
basepath 'la8b006';
basepath 'la8b005';
basepath 'la8b004';
basepath 'la4b005';
basepath 'la4b004';
basepath 'la4b003';
basepath 'la4b002';
basepath 'la4b001';
basepath 'la2d015';
basepath 'la2d014';
basepath 'la2d013';
basepath 'la2d012';
basepath 'la2d011';
basepath 'la2d010';
basepath 'la2d009';
basepath 'la2d008';
basepath 'la2d007';
basepath 'la2d006';
basepath 'la2d005';
basepath 'la2d004';
basepath 'la2d003';
basepath 'la2d002';
basepath 'la2c039';
basepath 'la2c038';
basepath 'la2c037';
basepath 'la2c036';
basepath 'la2c035';
basepath 'la2c034';
basepath 'la2c033';
basepath 'la2c032';
basepath 'la2c031';
basepath 'la2c030';
basepath 'la2c029';
basepath 'la2c028';
basepath 'la2c027';
basepath 'la2c026';
basepath 'la2c025';
basepath 'la2c024';
basepath 'la2c023';
basepath 'la2c022';
basepath 'la2c021';
basepath 'la2c020';
basepath 'la2c019';
basepath 'la2c018';
basepath 'la2c017';
basepath 'la2c016';
basepath 'la2c015';
basepath 'la2c014';
basepath 'la2c013';
basepath 'la2c012';
basepath 'la2c011';
basepath 'la2c010';
basepath 'la2c009';
basepath 'la2c008';
basepath 'la2c007';
basepath 'la2c006';
basepath 'la2c005';
basepath 'la2c004';
basepath 'la2c003';
basepath 'la2c002';
basepath 'la2b002';
basepath 'la2b001';
basepath 'la2b000'];

Lambda = [
1.999999
1.949999
1.899999
1.849999
1.799999
1.749999
1.699999
1.649999
1.600000
1.550000
1.500000
1.450000
1.400000
1.350000
1.300000
1.250000
1.200000
1.150000
1.100000
1.050000
1.000000
0.950000
0.900000
0.850000
0.800000
0.750000
0.700000
0.650000
0.600000
0.550000
0.500000
0.450000
0.400000
0.350000
0.300000
0.250000
0.300000
0.250000
0.200000
0.150000
0.100000
0.080000
0.075000
0.070000
0.065000
0.060000
0.055000
0.050000
0.045000
0.040000
0.035000
0.030000
0.025000
0.020000
0.015000
0.010000
0.009750
0.009500
0.009250
0.009000
0.008750
0.008500
0.008250
0.008000
0.007750
0.007500
0.007250
0.007000
0.006750
0.006500
0.006250
0.006000
0.005750
0.005500
0.005250
0.005000
0.004750
0.004500
0.004250
0.004000
0.003750
0.003500
0.003250
0.003000
0.002750
0.002500
0.002250
0.002000
0.001750
0.001500
0.001250
0.001000
0.000750
0.000750
0.000500
0.000250
 ];