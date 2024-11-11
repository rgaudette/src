%%  This script reads in the jamr00??v1.mat files and extracts the first 300
%%  samples from the first CPI of each file.  This data is then calibrated and
%%  equalize.


%%
%%    First load in the calibration and equalization coefficients.
%%
load m11d24ap
load m11d24cft

%%
%%    Loop over each file
%%
for indx = 1:23,

    %%
    %%    Load the file
    %%
    filenum = sprintf('%02.0f', indx);
    eval(['load jamr00' filenum 'v1'])

    %%
    %%    Check for appropriate cpi type
    %%
    if cpitype(1) ~= 5,
	disp(['WARNING : CPI type ' intstr(cpitype(1)) ' in file # ' ...
	    int2str(indx)]);
    end

    %%
    %%    Equalize the first 300 element of the first CPI.
    %%
    eval(['x' filenum '= eqapcpi(cpi1(1:300,:), 1, 1, 1, heq, apcal);']);
end
