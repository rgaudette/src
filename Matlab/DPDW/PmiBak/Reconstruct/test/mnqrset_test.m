m = 200;
n = 2000;
rmin = 800;
rmax = 820;
r = rmin:rmax;
nr = length(r);
A = randn(m,n);
b = randn(m, nr);
xmnqrset = mnqrset(A, b, rmin, rmax);
%xmnfatmn = zeros(rmax, nr);
%for ir = 1:nr
%    idxCol = (n - r(ir) + 1):n;
%    xmnfatmn(rmax-r(ir)+1:rmax,ir) = fatmn(A(:, idxCol), b(:, ir));
%end

%xdiff = max(xmnfatmn - xmnqrset);
