%CAUCHY_RIEMANN Cauchy-Reimann sol'n for E field lines from pot.
%
%   psi = cauchy_reimann(phi, bc)
function psi = cauchy_reimann(phi, bc)

[N M] = size(phi);
psi = zeros(M,N);

%%
%%  Find the center of the bounday conditions and assume symmetry
%%  we can write the first region of psi from this
%%
[nPts junk] = size(bc);
plate1 = bc(1:nPts/2,:);
plate2 = bc(nPts/2+1:nPts,:);
ctrX =  ceil(mean(plate1(:,2)));
c1 = [plate1(1,1) ctrX];
c2 = [plate2(1,1) ctrX];


%%
%%  Fill in the psi's using Cauchy-Reimann from the center
%%
iX = ctrX ;

while iX < M
    for iY = (c2(1)+1):(c1(1)-1)
        psi(iY, iX+1) = psi(iY, iX) - phi(iY+1, iX) + phi(iY, iX);
    end
    iX = iX + 1;
end

iY = c1(1)-1;
while iY < N
    for iX = max(plate1(:,2))+1:M
        psi(iY+1, iX) = psi(iY, iX) + phi(iY, iX) - phi(iY, iX-1);
    end
    iY = iY + 1;
end

iY = c2(1)+1;
while iY > 1
    for iX = max(plate1(:,2))+1:M
        psi(iY-1, iX) = psi(iY, iX) + phi(iY, iX-1) - phi(iY, iX);
    end
    iY = iY - 1;
end

iX = max(plate1(:,2))+1;
while iX >= ctrX
    for iY = (c1(1)+1):M
        psi(iY, iX-1) = psi(iY, iX) - phi(iY-1, iX) + phi(iY, iX);
    end
    iX = iX - 1;
end

iX = max(plate1(:,2))+1;
while iX >= ctrX
    for iY = (c2(1)-1):-1:1
        psi(iY, iX-1) = psi(iY, iX) - phi(iY, iX) + phi(iY+1, iX);
    end
    iX = iX - 1;
end

%%
%%  Mirror the stream field to the left hand side
%%
psi(:,1:ctrX) = fliplr(psi(:,ctrX+1:M));

%%
%%  Set the plates to NaN to kill the contour bunches
%%
for i = 1:nPts
    psi(bc(i,1),bc(i,2)) = nan;
end
