%
%  F0155 data set
%
load F0155c193_spine_profile.dat
F0155c193BadList = 3;
[F0155c193MNDmarg F0155c193MNDnmarg F0155c193MNDmndist] = ...
    runMinNormDiff(F0155c193_spine_profile, 800, F0155c193BadList);

[F0155c193MNMDmarg F0155c193MNMDnmarg F0155c193MNMDmndist] = ...
    runMinNormMeanDiff(F0155c193_spine_profile, 800, F0155c193BadList);

[F0155c193MHWRmarg F0155c193MHWRnmarg F0155c193MHWRmndist] = ...
    runMeanHWRatio(F0155c193_spine_profile, 800, F0155c193BadList);

load F0155c290_spine_profile.dat
F0155c290BadList = 8;
[F0155c290MNDmarg F0155c290MNDnmarg F0155c290MNDmndist] = ...
    runMinNormDiff(F0155c290_spine_profile, 800, F0155c290BadList);

[F0155c290MNMDmarg F0155c290MNMDnmarg F0155c290MNMDmndist] = ...
    runMinNormMeanDiff(F0155c290_spine_profile, 800, F0155c290BadList);

[F0155c290MHWRmarg F0155c290MHWRnmarg F0155c290MHWRmndist] = ...
    runMeanHWRatio(F0155c290_spine_profile, 800, F0155c290BadList);

load F0155Joined
[F0155MNDmarg F0155MNDnmarg F0155MNDmndist] = ...
    runMinNormDiff(F0155_spine_profile, 800, F0155BadList);

[F0155MNMDmarg F0155MNMDnmarg F0155MNMDmndist] = ...
    runMinNormMeanDiff(F0155_spine_profile, 800, F0155BadList);

[F0155MHWRmarg F0155MHWRnmarg F0155MHWRmndist] = ...
    runMeanHWRatio(F0155_spine_profile, 800, F0155BadList);

%
%  MT19D data set
%

load MT179Joined
[MT179MNDmarg MT179MNDnmarg MT179MNDmndist] = ...
    runMinNormDiff(MT179_spine_profile, 650, MT179BadList);

[MT179MNMDmarg MT179MNMDnmarg MT179MNMDmndist] = ...
    runMinNormMeanDiff(MT179_spine_profile, 800, MT179BadList);

[MT179MHWRmarg MT179MHWRnmarg MT179MHWRmndist] = ...
    runMeanHWRatio(MT179_spine_profile, 650, MT179BadList);

%%
%%  Skiff data set 400 FOV
%%
load SKIFF_spine_profile.dat
SkiffBadList = 11;
[SkiffMNDmarg SkiffMNDnmarg SkiffMNDmndist] = ...
    runMinNormDiff(SKIFF_spine_profile, 400, SkiffBadList);

[SkiffMNMDmarg SkiffMNMDnmarg SkiffMNMDmndist] = ...
    runMinNormMeanDiff(SKIFF_spine_profile, 800, SkiffBadList);

[SkiffMHWRmarg SkiffMHWRnmarg SkiffMHWRmndist] = ...
    runMeanHWRatio(SKIFF_spine_profile, 400, SkiffBadList);
