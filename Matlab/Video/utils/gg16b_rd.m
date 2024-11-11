%%
%%  Load in the appropriate data sets
%%
load /usr/site/cdsp/scratch/hoag/Codebook/Source/gg07_0a


%%
%%  Run the ratedist fucntion against each data set
%%
[recgg16b decgg16b erecgg16b] = ratedist('ecvqgg16', data(950000:1000000), 2);

%%
%%  Save the results
%%
save gg16b_rd recgg16b decgg16b erecgg16b
