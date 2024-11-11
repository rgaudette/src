%%
%%  Load in the appropriate data sets
%%
load /usr/site/cdsp/scratch/hoag/Codebook/Source/gg07_0a


%%
%%  Run the ratedist fucntion against each data set
%%
[recgg_1 decgg_1 erecgg_1] = ratedist('ecvqggcb', data(1:50000), 2);
[recgg_2 decgg_2 erecgg_2] = ratedist('ecvqggcb', data(950000:1000000), 2);

save gg_rd recgg_1 decgg_1 erecgg_1  recgg_2 decgg_2 erecgg_2


[rvqgg_1 dvqgg_1] = ratedist('gg_cb', data(1:50000), 1);
[rvqgg_2 dvqgg_2] = ratedist('gg_cb', data(950000:1000000), 1);

%%
%%  Save the results
%%
save gg_rd recgg_1 decgg_1 erecgg_1  recgg_2 decgg_2 erecgg_2 ...
 rvqgg_1 dvqgg_1 rvqgg_2 dvqgg_2

