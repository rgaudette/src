%PERFXY         Performance of increasing matrix multiplication orders.
%
%  This is also affected by the speed of for loop iteration size the
%  small matrices need to be multiplied a number of times to execute
%  for a measureable amount of time.


%%
%%  Minimum, maximum and step sizes for the matrix dimensions
%%
min = 50;
max = 300;
step = 4;
z = rand(max);
ordinate = [min:step:max];
FLOPS = inf*ones(size(ordinate));
length(FLOPS);
l = 1;
for i=min:step:max,

    %%
    %%  Compute rough # of flops at current size perform ~1 sec at least
    %%
    fl = i^3;

    niter = ceil(30e6 / fl);
    x = z(1:i,1:i);
    y = x';
    currfl = flops;
    st = clock;
    for j = 1:niter
        w = x*y;
    end
    et = etime(clock, st);
    endfl = flops - currfl;
    FLOPS(l) = endfl/et;

    plot(ordinate,FLOPS, '-')
    drawnow;
    l = l+1;
end
