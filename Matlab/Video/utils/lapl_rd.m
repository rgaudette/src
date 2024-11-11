%%
%%  Load in the appropriate data sets
%%
load /usr/site/cdsp/scratch/hoag/Codebook/Source/lapliid1
lapliid1 = lapliid;
load /usr/site/cdsp/scratch/hoag/Codebook/Source/lapliid1
lapliid2 = lapliid;
clear lapliid

%%
%%  Run the ratedist fucntion against each data set
%%
[recla_1 decla_1 erecla_1] = ratedist('ecvqlacb', lapliid1(1:50000), 2);
[recla_2 decla_2 erecla_2] = ratedist('ecvqlacb', lapliid2(1:50000), 2);

[rvqla_1 dvqla_1] = ratedist('lapl_cb', lapliid1(1:50000), 1);
[rvqla_2 dvqla_2] = ratedist('lapl_cb', lapliid2(1:50000), 1);

%%
%%  Save the results
%%
save lapl_rd recla_1 decla_1 erecla_1  recla_2 decla_2 erecla_2 ...
 rvqla_1 dvqla_1 rvqla_2 dvqla_2

