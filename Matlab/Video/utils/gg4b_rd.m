%%
%%  Load in the appropriate data sets
%%
load /usr/site/cdsp/scratch/hoag/Codebook/Source/gg07_0a


%%
%%  Run the ratedist fucntion against each data set
%%
[recgg4b decgg4b erecgg4b] = ratedist('ecvqgg4b', data(950000:1000000), 2);

%%
%%  Save the results
%%
save gg4b_rd recgg4b decgg4b erecgg4b



