
function regc = lcorner_simple2deriv(resid, xnorm)

resid = log(resid);
xnorm = log(xnorm);
%%
%% compute the first deriv estimates for each pair of points as well as the 
%% position of the estimate since the data is not uniformly sampled
%%
[d2f_dx2, dx2] = nu2deriv(resid, xnorm)
[val id2max] = max(d2f_dx2);

[val regc] = min(abs(resid - dx2(id2max)));

figure(2)
clf

subplot(2,1,2)
plot(resid, xnorm)
subplot(2,1,1)
plot(dx2,d2f_dx2)

