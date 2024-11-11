%Example of Jacobi iterations to solve the 3D Helmholtz equation on infinite
%   domain by setting the boundary values equal to the 
%
hx = 0.16;
hy = hx;
x = [-3:hx:3]; y = x;

z = [-1:hx:5];
hz = hx;
nX = length(x); nY = length(y);nZ = length(z);
dt =  hx^2 / 6.1;

%%
%%  Compute the spatial wavenumber function
%%
w = 200E6 * 2 * pi;
v = 3E10 / 1.37;
mu_sp = 10;
D = v / (3 * mu_sp);
mu_a = 0.041;
ksq_back = (j * w - v * mu_a) / D

ksq = ksq_back * ones(nY, nX, nZ);
SpCtr = [0 0 3];
SpRad = 1;
del_ksq = 0.0 * v / D;
CompVol.Type = 'uniform';
CompVol.X = x; CompVol.Y = y; CompVol.Z = z;
ksq = gensphere1(CompVol, SpCtr, SpRad, del_ksq) + ksq;

%%
%%  Scale the source by the volume of the voxel for a point source
%%
SrcPos = [0 0 0.1];
[junk iSrcX] = min(abs(x - SrcPos(1)));
[junk iSrcY] = min(abs(y - SrcPos(2)));
[junk iSrcZ] = min(abs(z - SrcPos(3)));
[iSrcX iSrcY iSrcZ]
s = zeros(nY, nX, nZ);
s(iSrcY, iSrcX, iSrcZ) = 3 * mu_sp /  hx ^3;


%%
%%  Compute the detector Y and Z indices
%%
DetPos = [0 0 0];
[junk iDetY] = min(abs(y - DetPos(2)));
[junk iDetZ] = min(abs(z - DetPos(3)));
[iSrcX iDetY iDetZ]


%%
%%  Green's function solution
%%
k = sqrt(ksq_back)
[mX mY mZ] = meshgrid(x - SrcPos(1), y - SrcPos(2), z - SrcPos(3));
r = sqrt(mX.^2 + mY.^2 + mZ.^2);
clear mX mY mZ
greens = 3 * mu_sp * exp(j*k*r) ./ (-4*pi*r);
clear r

%%
%%  Set the boundaries equal to the Green's solution for the infinite
%%  medium
%%
fOld = greens;
fOld(iSrcY, iSrcX, iSrcZ) = s(iSrcY, iSrcX, iSrcZ);
fOld(2:nY-1, 2:nX-1, 2:nZ-1) = zeros(nY-2, nX-2,nZ-2);
fNew = fOld;

clf
semilogy(x, abs(fNew(iDetY, :, iDetZ)))
hold on
semilogy(x, abs(greens(iDetY, :, iDetZ)), 'g--')
pause

nIter = 100000;
maxError = 1E-6;
rx = dt / hx ^ 2;
ry = dt / hy ^ 2;
rz = dt / hz ^ 2;
for jIter = 1:nIter
    fNew(2:nY-1,2:nX-1,2:nZ-1) =  ...
        rx * (fOld(2:nY-1,3:nX,2:nZ-1) - ...
        2*fOld(2:nY-1,2:nX-1,2:nZ-1) + fOld(2:nY-1,1:nX-2,2:nZ-1)) + ...
        ry * (fOld(3:nY,2:nX-1,2:nZ-1) - ...
        2*fOld(2:nY-1,2:nX-1,2:nZ-1) + fOld(1:nY-2,2:nX-1,2:nZ-1)) + ...
        rz * (fOld(2:nY-1,2:nX-1,3:nZ) - ...
        2*fOld(2:nY-1,2:nX-1,2:nZ-1) + fOld(2:nY-1,2:nX-1,1:nZ-2)) + ...
        fOld(2:nY-1,2:nX-1,2:nZ-1) + ...
        dt * ksq(2:nY-1,2:nX-1,2:nZ-1) .* fOld(2:nY-1,2:nX-1,2:nZ-1) - ...    
        dt * s(2:nY-1,2:nX-1,2:nZ-1);

    if rem(jIter, 100) == 0
        clf
        semilogy(x, abs(fNew(iDetY, :, iDetZ)))
        hold on
        semilogy(x, abs(greens(iDetY, :, iDetZ)), 'g')
        drawnow
    end
    paerr = max(abs((fNew(:) - fOld(:))));
    if paerr < maxError;
        break;
    end
    fOld = fNew;
end
paerr
jIter
figure(1)
clf
subplot(2,1,1)
semilogy(x, abs(fNew(iDetY, :, iDetZ)))
hold on
semilogy(x, abs(greens(iDetY, :, iDetZ)), 'g')
scat_field = fNew - greens;
semilogy(x, abs(scat_field(iDetY, :, iDetZ)), 'r')

subplot(2,1,2)
plot(x, angle(fNew(iDetY, :, iDetZ)))
hold on
plot(x, angle(greens(iDetY, :, iDetZ)), 'g')
plot(x, angle(scat_field(iDetY, :, iDetZ)), 'r')