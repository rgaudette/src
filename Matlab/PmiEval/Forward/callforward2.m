r_s=struct('x',0,'y',0,'z',-2);
r_r=struct('x',0,'y',0,'z',2);
r_obj=struct('x',0,'y',0,'z',0,'radius',0.5);
back=struct('mu_a',[0.01],'mu_s',[10.0],'w',[100e6],'v',3e10/1.3,'S_AC',1);
obj=struct('mu_a',[0.1],'mu_s',[10.0],'w',[100e6],'v',3e10/1.3);


x=-2.5:.1:2.5;
y=-2.5:.1:2.5;
kout=sqrt((-back.v*back.mu_a+i*back.w)/(back.v/(3*(back.mu_s+back.mu_a))))
kin=sqrt((-obj.v*obj.mu_a+i*obj.w)/(obj.v/(3*(obj.mu_s+obj.mu_a))))
Dout=(back.v/(3*(back.mu_s+back.mu_a)));


for c=1:length(x)
    r_r.x=x(c)
    for c2=1:length(y)
        r_r.y=y(c2)
        phi=aforward2(r_s,r_r,r_obj,back,obj,2,2);
        phi_scatt(c,c2)=phi;
        r=sqrt((r_r.x-r_s.x)^2+(r_r.y-r_s.y)^2+(r_r.z-r_s.z)^2);
        phi_source(c,c2)=(back.S_AC/r)*exp(i*kout*r);
    end
end

figure;
subplot(2,1,1);
imagesc(x,y,abs(phi_scatt));
title('Scattered Field Amplitude');
colorbar;

subplot(2,1,2);
imagesc(x,y,angle(phi_scatt)*180/pi);
xlabel('Transverse to Source, Object, Receiver plan [cm]');
title('Scattered Field Phase');
colorbar;

figure;
subplot(2,1,1);
imagesc(x,y,abs(phi_scatt+phi_source));
title('Total Field Amplitude');
colorbar;

subplot(2,1,2);
imagesc(x,y,angle(phi_scatt+phi_source)*180/pi);
xlabel('Transverse to Source, Object, Receiver plan [cm]');
title('Total Field Pahse');
colorbar;