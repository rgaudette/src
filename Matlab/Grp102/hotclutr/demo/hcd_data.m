%%
%%    Load system constants, cw data, and noise if present
%%
disp('Loading auxilliary data ...')
load cons_dat
load cw_data

if(exist('nois_dat.mat') == 2),
    load noise_dat
end

%%
%%    Load file of interest
%%
disp('Loading data file ...');
load r2281263v1

%%
%%    Extract RSTER azimuth
%%
Azimuth = mean(azxmit);

%%
%%    Range process data
%%
fprintf('    Computing %f degree radial range response\n', Azimuth)

proc13

%%
%%    Compute sigma-0
%%
[Sigma0 NoiseFlr Range] = sigma0(mfout, tDelta * 3e8, Azimuth, TxPos, DirPathdB, 46);
