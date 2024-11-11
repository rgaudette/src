function [diff]=cali(usa,FF0)
%FF0=measure([10,0.04],0.2,0.05);

us0=usa(1);
ua0=usa(2);
%s1d1=usa(3);
g=0;
n=1.37;
R=(n-1)^2/(n+1)^2;
uc=cos(asin(1/n));
D0=1/(3*(ua0+us0*(1-g)));
ueff0=(3*ua0*us0*(1-g))^0.5;
k1=(1-R)*(1-uc^2)/((1+R)+(1-R)*uc^3);
zs0=1/(us0*(1-g));
ze=2*D0/k1;
zs1=-(2*ze+zs0);           
%--geo of trhe rat probe
Ns=9;
Nd=16;
xs=reshape(repmat(0.5:1:2.5,[sqrt(Ns),1]),[1,Ns]);
ys=repmat(0.5:1:2.5,[1,3]);
xd=reshape(repmat(0:1:3,[sqrt(Nd),1]),[1,Nd]);
yd=repmat(0:1:3,[1,sqrt(Nd)]);
zd=0;

FF1=zeros(Ns,Nd); 
for is=1:Ns,
    for id=1:Nd,
        r11=sqrt((xs(is)-xd(id)).^2+(ys(is)-yd(id)).^2+zs0^2);
        r12=sqrt((xs(is)-xd(id)).^2+(ys(is)-yd(id)).^2+7/3*zs0^2);
        F1=(1./(4*pi*D0*r11)).*exp(-ueff0*r11);
        F11=-(1./(4*pi*D0*r12)).*exp(-ueff0*r12);
        FF1(is,id)=(F1+F11);
    end
end
%-------coupling coefficient of s-d
%- S(i) vs D(1)
S1=zeros(Ns,1);
D1=zeros(Nd,1);

for j=1:Nd, 
    for i=1:Ns,
        D1(j)=D1(j)+1/Ns*FF1(i,j)/FF0(i,j)*FF0(i,1)/FF1(i,1);
    end
end
for i=1:Ns,
    for j=1:Nd,
        S1(i)=S1(i)+1/Nd*FF1(i,j)/(FF0(i,j)*D1(j));
    end
end
%----relation of D(j) vs S(1)
S2=zeros(Ns,1);
D2=zeros(Nd,1);

for i=1:Ns,
    for j=1:Nd,
        S2(i)=S2(i)+1/Nd*FF1(i,j)/FF0(i,j)*FF0(1,j)/FF1(1,j);
    end
end

for j=1:Nd
    for i=1:Ns,
        D2(j)=D2(j)+1/Ns*FF1(i,j)/(FF0(i,j)*S2(i));
    end
end

%-----
diff=0;
for i=1:Ns,
    for j=1:Nd,
        diff=diff+1/Ns*Nd*((S1(i)*D2(j)*FF0(i,j)-FF1(i,j))/FF1(i,j))^2;
    end
end
