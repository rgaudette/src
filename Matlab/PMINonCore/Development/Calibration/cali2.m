%CALI2          More efficient calibration cost function
%
%    [diff]=cali2(usa, FF0, lstSrcGood, lstDetGood)
%
%    usa        [mu_sp mu_a] estimate
%
%    FF0        Measured data as nSrc x nDet matrix
%
%    lstSrcGood OPTIONAL: List of good sources (default: all).
%
%    lstDetGood OPTIONAL: List of good detectors (default: all).

function [diff] = cali2(usa, FF0, lstSrcGood, lstDetGood)

[Ns Nd] = size(FF0);
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
FF0 = FF0(lstSrcGood, lstDetGood);

us0=usa(1);
ua0=usa(2);
g=0;
n=1.37;
R=(n-1)^2/(n+1)^2;
uc=cos(asin(1/n));
D0=1/(3*(ua0+us0*(1-g)));
ueff0=(3*ua0*us0*(1-g))^0.5;
k1=(1-R)*(1-uc^2)/((1+R)+(1-R)*uc^3);
zs0=1/(us0*(1-g));
ze=2*D0/k1;
%%
%%  BUG??? Compute zs1 but never use it 
%%
zs1 = -(2 * ze + zs0);           

%--geo of the rat probe

[XSrc YSrc] = meshgrid([0.5:1:2.5], [0.5:1:2.5]);
XSrc = XSrc(lstSrcGood);
YSrc = YSrc(lstSrcGood);

[XDet YDet] = meshgrid([0:1:3], [0:1:3]);
XDet = XDet(lstDetGood);
YDet = YDet(lstDetGood);

zd=0;
nSrcGood = length(lstSrcGood); 
nDetGood = length(lstDetGood);
FF1=zeros(nSrcGood, nDetGood); 
for iSrc = 1:nSrcGood

    %%
    %%  Distance from source to the detectors
    %%
    rxy_sq = (XSrc(iSrc)-XDet).^2 + (YSrc(iSrc)-YDet).^2;
    rsd = sqrt(rxy_sq + zs0^2);
    F1=(1./(4*pi*D0*rsd)).*exp(-ueff0*rsd);

    %%
    %%  Distance from image source to detector
    %%
    %%  BUG??: 7/3 * zs0 ^ 2 or (7/3 * zs0) ^ 2;
    rsd = sqrt(rxy_sq + (7/3*zs0)^2);
    FF1(iSrc, :) = F1 - (1./(4*pi*D0*rsd)) .* exp(-ueff0*rsd);
end

%-------coupling coefficient of s-d
%- S(i) vs D(1)
S1=zeros(nSrcGood, 1);
D1=zeros(nDetGood, 1);

%%
%%  Estimate coupling coefficient for each detector
%%
for iDet = 1:nDetGood 
    D1(iDet) = mean(FF1(:, iDet) .* FF0(:,1) ./ (FF0(:, iDet)  .* FF1(:,1)));
end

%%
%%  Estimate coupling coefficient for each source
%%
for iSrc = 1:nSrcGood
    S1(iSrc) = mean(FF1(iSrc, :) ./ (FF0(iSrc, :) .* D1(:).'));
end
%----relation of D(j) vs S(1)
S2=zeros(nSrcGood, 1);
D2=zeros(nDetGood, 1);

for iSrc = 1:nSrcGood
    S2(iSrc) = mean(FF1(iSrc, :) .* FF0(1,:) ./ (FF0(iSrc, :) .* FF1(1,:)));
end

for iDet = 1:nDetGood
    D2(iDet) = mean(FF1(:, iDet) ./ (FF0(:, iDet) .* S2(:)));
end

%-----
%%
%%  Another BUG???  1/Ns * Nd or 1/(Ns * Nd)
%diff=0;
%for i=1:Ns,
%    for j=1:Nd,
%        diff=diff+1/Ns*Nd*( (S1(i)*D2(j)*FF0(i,j)-FF1(i,j))/FF1(i,j) )^2;
%    end
%end
diff = mean(mean((((S1 * D2.') .* FF0 - FF1) ./ FF1).^2) );
