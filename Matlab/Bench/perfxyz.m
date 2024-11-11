%PERFXY         Performance of increasing matrix multiplication orders.

min = 32
max = 256;
step = 16;
z = rand(max);
FLOPS = inf*ones(1,(max-min)/step+1);
l = 1;
for i=min:step:max,

    %%
    %%  Compute rough # of flops at current size perform ~1 sec at least
    %%
    fl = i^3;

    niter = ceil(2e6 / fl);
    x = z(1:i,1:i);
    y = x';
    w = y;
    t = y;
    currfl = flops;
    st = clock;
%    for j = 1:niter
        w = t*x*y;
%    end
    et = etime(clock, st);
    endfl = flops - currfl;
    FLOPS(l) = endfl/et;

    plot([min:step:max],FLOPS, '-')
    drawnow;
    l = l+1;
end
