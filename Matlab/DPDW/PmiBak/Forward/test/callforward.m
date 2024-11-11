r_s=struct('r',2,'theta',pi,'phi',0);
r_r=struct('r',2.1,'theta',0,'phi',0);
r_obj=struct('r',0,'theta',0,'phi',0,'radius',0.5);
back=struct('mu_a',[0.01],'mu_s',[10.0],'w',[100e6],'v',3e10/1.3,'S_AC',1);
obj=struct('mu_a',[0.502],'mu_s',[10.0],'w',[100e6],'v',3e10/1.3);


kout=sqrt((-back.v*back.mu_a+i*back.w)/(back.v/(3*(back.mu_s+back.mu_a))))
kin=sqrt((-obj.v*obj.mu_a+i*obj.w)/(obj.v/(3*(obj.mu_s+obj.mu_a))))
Dout=(back.v/(3*(back.mu_s+back.mu_a)));

for c=1:360
     r_r.theta=c*pi/180;	% Please Pass angles in Radians
  	  phi=aforward(r_s,r_r,r_obj,back,obj,2,2);
     phi_scatt(c)=phi;
     [r1.x,r1.y,r1.z] = sph2cart(r_r.phi,pi/2-r_r.theta,r_r.r);% I measure theta from z axis and matlab measures from x-y plan
     [r2.x,r2.y,r2.z] = sph2cart(r_s.phi,pi/2-r_s.theta,r_s.r);
     r=sqrt((r1.x-r2.x)^2+(r1.y-r2.y)^2+(r1.z-r2.z)^2);
     if(r==0)
        phi_sourc(c)=back.S_AC;
     else
        phi_source(c)=(back.S_AC/r)*exp(i*kout*r);
     end
end;

figure;
subplot(2,1,1);
plot(abs(phi_scatt));
title('Scattering  Amplitude');

subplot(2,1,2);
plot(angle(phi_scatt)*180/pi);
xlabel('Receiver Angle in degrees');
title('Scattering Angle');


figure;
subplot(2,1,1);
plot(abs(phi_scatt+phi_source));
title('Scattering and Incident Amplitude');

subplot(2,1,2);
plot(angle(phi_scatt+phi_source)*180/pi);
xlabel('Receiver Angle in degrees');
title('Scattering and Incident Angle');
