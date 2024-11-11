%%
%%  Load in the appropriate data sets
%%
load /usr/site/cdsp/scratch/hoag/Codebook/Source/gg07_0a


%%
%%  Run the ratedist fucntion against each data set
%%
[recgg8b decgg8b erecgg8b] = ratedist('ecvqgg8b', data(950000:1000000), 2);

%%
%%  Save the results
%%
save gg8b_rd recgg8b decgg8b erecgg8b
