%buildMT179     Build a profile array from separate MT179 profile files
%
%
MT179_spine_profile = [];
MT179BadList = [];

%load MT179_G1C103_spine_profile.dat
%MT179G1C103BadList = 5;

%nPins = size(MT179_spine_profile, 1) / 2;
%MT179_spine_profile = [MT179_spine_profile; MT179_G1C103_spine_profile];
%MT179BadList = [MT179BadList MT179G1C103BadList+nPins];

load MT179_G1C137_spine_profile.dat
MT179G1C137BadList = 9;

nPins = size(MT179_spine_profile, 1) / 2;
MT179_spine_profile = [MT179_spine_profile; MT179_G1C137_spine_profile];
MT179BadList = [MT179BadList MT179G1C137BadList+nPins];

load MT179_G2C211_spine_profile.dat
MT179G2C211BadList = 1;

nPins = size(MT179_spine_profile, 1) / 2;
MT179_spine_profile = [MT179_spine_profile; MT179_G2C211_spine_profile];
MT179BadList = [MT179BadList MT179G2C211BadList+nPins];

load MT179_G4C1109_spine_profile.dat
MT179G4C1109BadList = 8;

nPins = size(MT179_spine_profile, 1) / 2;
MT179_spine_profile = [MT179_spine_profile; MT179_G4C1109_spine_profile];
MT179BadList = [MT179BadList MT179G4C1109BadList+nPins];

load MT179_G4C1229_spine_profile.dat
MT179G4C1229BadList = 7;

nPins = size(MT179_spine_profile, 1) / 2;
MT179_spine_profile = [MT179_spine_profile; MT179_G4C1229_spine_profile];
MT179BadList = [MT179BadList MT179G4C1229BadList+nPins];

%
%  Good or questionable pins
%
load MT179_E2C1066_spine_profile.dat
MT179_spine_profile = [MT179_spine_profile; MT179_E2C1066_spine_profile(9:16,:)];

load MT179_D2C1209_spine_profile.dat
MT179_spine_profile = [MT179_spine_profile; MT179_D2C1209_spine_profile];

