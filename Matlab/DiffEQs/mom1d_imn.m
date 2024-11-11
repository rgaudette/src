%MOM1D_IMN      Generate Harrington's I matrix (the transmitance matrix)
%
%    I = mom1d_imn(k, a, l, nElems)

function I = mom1d_imn(k, a, l, nElems)

%%
%%  Discretize the antenna into elements
%%
dz = l / nElems;

%%
%%  Assume free space
%%
C = 3E8;
mu = 4 * pi * 1E-7;
w = k * C;
I = zeros(nElems, nElems);
dzsq = dz ^ 2;
iksq = k ^ -2;
for m = 1:nElems
    m
    for n = 1:nElems
        I(m,n) = j * w * mu * a / 2 * (dzsq * mom1d_psi(m, n, k, a, dz) - ...
          iksq * (mom1d_psi(m + 0.5, n + 0.5, k, a, dz) - ...
                  mom1d_psi(m - 0.5, n + 0.5, k, a, dz) - ...
                  mom1d_psi(m + 0.5, n - 0.5, k, a, dz) + ...
                  mom1d_psi(m - 0.5, n - 0.5, k, a, dz) ));
          
    end
end



