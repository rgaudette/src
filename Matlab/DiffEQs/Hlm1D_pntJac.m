%Example of Jacobi iterations to solve the 1D Helmholtz equation on infinite
%   domain by setting the boundary values equal to the 
%
h = 0.05;
x = [-1:h:1];
nSamp = length(x);
fOld = zeros(nSamp,1);
fNew = fOld;
ksq_real = 0.2;
ksq_imag = 0.2;
ksq = ksq_real * ones(nSamp,1) + j * ksq_imag * ones(nSamp, 1);
ctr = round(nSamp/2)
s = fOld;
s(ctr) = 1;
dt = 0.45* h^2
r = dt / h^2;

%%
%%  Green's function solution
%%
k = sqrt(ksq_real + j * ksq_imag);
greens = -j / (2*k) * exp(j*k * abs(x));
left_bnd = -j / ( 2*k) * exp(j* k *abs(min(x) - h))
right_bnd = -j / (2* k) * exp(j* k *abs(max(x) + h))

%nIter = 100000
%maxError = 1E-6;
%for jIter = 1:nIter
%    fNew = r * [fOld(2:nSamp); right_bnd] + r * [left_bnd; fOld(1:nSamp-1)] + ...
%        (1 - 2 * r + dt * ksq) .* fOld - dt * s;
%    paerr = max(abs((fNew - fOld) ./ dt));
%    if paerr < maxError;
%        break;
%    end
%    fOld = fNew;

%end
%err
%jIter
clf
%plot(x, real(fNew))
expr = 1/h^2 * ([greens(2:end)'; right_bnd] + [left_bnd; greens(1:end-1)'] - 2 *greens') + ksq .* greens';
plot(x, real(greens), 'g')
hold on
plot(x, imag(greens), 'm')
plot(x,real(expr), 'g--')
plot(x,imag(expr), 'm--')

%plot(x, imag(fNew), 'r')
