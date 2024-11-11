%MOM1D_PSI      Method of momements psi generator
%
%  psi = mom1d_psi(m, n, k, a, dz)

function psi = mom1d_psi(m, n, k, a, dz)

thresh = 0.9;

if abs(m-n) <= thresh
    psi = -j * k + 2 / dz * asinh(dz / (2*a));
else
    zdsq = ((m - n) * dz) .^ 2;
    dsq = zdsq + a .^2;
    d = sqrt(dsq);
    
    psi = exp(-j*k*d) ./ d * ...
        (1 + (dz * k).^2 * zdsq / (12 * dsq) * (-0.5 - 1/(j*k*d)));
end
