load m11d24ap
load m11d24cft
load jamr0022v1

z=eqapcpi(cpi1,npulses(1),1,1,heq,apcal);

%
%   Subsample z matrix by a factor of 4 (decorelates noise, bandwidth
% for signal is approx 200khz, samp rate is 1 MSa/s
%
z_sub = z(1:4:465,:);

%%
%%    Create Conv. beam forming stearing vector.
%%
w_cbf = svrster(14, [0:0.25:45], 1, 3, 50);

%%
%%   Compute conventional beam forming response
%%
y_cbf = z_sub * w_cbf;
