%CALI3          More efficient calibration cost function
%
%    [diff]=cali3(usa, phi_meas, lstSrcGood, lstDetGood)
%
%    usa        [mu_sp mu_a] estimate
%
%    phi_meas        Measured data as nSrc x nDet matrix
%
%    lstSrcGood OPTIONAL: List of good sources (default: all).
%
%    lstDetGood OPTIONAL: List of good detectors (default: all).

function [diff] = cali3(vOpParm, phi_meas, lstSrcGood, lstDetGood)

[Ns Nd] = size(phi_meas);
if nargin < 4
    lstDetGood = [1:Nd];
else
    lstDetGood = lstDetGood(:)';
end
if nargin < 3
    lstSrcGood = [1: Ns]';
else
    lstSrcGood = lstSrcGood(:);
end

%%
%%  Select the good data
%%
phi_meas = phi_meas(lstSrcGood, lstDetGood);

mu_sp = vOpParm(1);
mu_a = vOpParm(2);
w = 0;
idxRefr=1.37;
zSrc = 1 / mu_sp;
zBnd = calcExtBnd(idxRefr, mu_sp);
zImg = -2 * zBnd - zSrc;
v = 3E10 / idxRefr;
D = v / (3 * (mu_sp + mu_a));
%D = v / (3 * mu_sp);
k = sqrt((j*w - v * mu_a) / D);

[XSrc YSrc] = meshgrid([0.5:1:2.5], [0.5:1:2.5]);
XSrc = XSrc(lstSrcGood);
YSrc = YSrc(lstSrcGood);

[XDet YDet] = meshgrid([0:1:3], [0:1:3]);
XDet = XDet(lstDetGood);
YDet = YDet(lstDetGood);

nSrcGood = length(lstSrcGood); 
nDetGood = length(lstDetGood);
phi_est = zeros(nSrcGood, nDetGood); 
for iSrc = 1:nSrcGood
    rxy_sq = (XSrc(iSrc)-XDet).^2 + (YSrc(iSrc)-YDet).^2;

    %%
    %%  Distance from source to the detectors
    %%
    rsd = sqrt(rxy_sq + zSrc^2);
    phi_source = -1./(4*pi*rsd) .* exp(j * k * rsd);
    %%
    %%  Distance from image source to detector
    %%
    rsd = sqrt(rxy_sq + zImg^2);
    phi_est(iSrc, :) = phi_source + 1./(4*pi*rsd) .* exp(j * k * rsd);
end
phi_est = -v/D * phi_est;
%-------coupling coefficient of s-d
%- S(i) vs D(1)
S1=zeros(nSrcGood, 1);
D1=zeros(nDetGood, 1);

%%
%%  Estimate coupling coefficient for each detector
%%
for iDet = 1:nDetGood 
    D1(iDet) = mean(phi_est(:, iDet) .* phi_meas(:,1) ./ (phi_meas(:, iDet) ...
                                                  .* phi_est(:,1)));
end

%%
%%  Estimate coupling coefficient for each source
%%
for iSrc = 1:nSrcGood
    S1(iSrc) = mean(phi_est(iSrc, :) ./ (phi_meas(iSrc, :) .* D1(:).'));
end
%----relation of D(j) vs S(1)
S2=zeros(nSrcGood, 1);
D2=zeros(nDetGood, 1);

for iSrc = 1:nSrcGood
    S2(iSrc) = mean(phi_est(iSrc, :) .* phi_meas(1,:) ./ (phi_meas(iSrc, :) ...
                                                  .* phi_est(1,:)));
end

for iDet = 1:nDetGood
    D2(iDet) = mean(phi_est(:, iDet) ./ (phi_meas(:, iDet) .* S2(:)));
end

%-----
%%
%%  Another BUG???  1/Ns * Nd or 1/(Ns * Nd)
%diff=0;
%for i=1:Ns,
%    for j=1:Nd,
%        diff=diff+1/Ns*Nd*( (S1(i)*D2(j)*phi_meas(i,j)-phi_est(i,j))/phi_est(i,j) )^2;
%    end
%end
diff = mean(mean((((S1 * D2.') .* phi_meas - phi_est) ./ phi_est).^2) );
