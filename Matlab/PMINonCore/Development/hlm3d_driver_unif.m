hx = 0.1 * ones(30,1);
hy = hx;
hz = hx;
w = 200E6 * 2 * pi;
v = 3E10 / 1.37;
mu_sp = 10;
D = v / (3 * mu_sp);
mu_a = 0.041;
ksqback = (j * w - v * mu_a) / D * ones(30, 30, 30);

S = zeros(30, 30, 30);
S(10,10,10) = -3 * mu_sp;
st = clock;
phi = Hlm3DFDFDVarStep(ksqback, S, hx, hy, hz);
et = etime(clock, st)
save hlm3_test phi
save hlm_test_time et

