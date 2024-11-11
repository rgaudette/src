function [phi_scatt]=aforward2(r_s,r_r,r_obj,back,obj,l,m);
%AFORWARD            Analytic Spherical Bessel Function Solution
%							for single spherical scatter at origin
%
% Structures Passed:
%
%		r_s=struct('x',[0],'y',[0],'z',[0]);
%
%		r_r=struct('x',[0],'y',[0],'z',[0]);
%
%		r_obj=struct('x',[0],'y',[0],'z',[0],'radius',[1]);
%
%		back=struct('mu_a',[0.001],'mu_s',[10.0],'w',[70e6],'v',3e10/1.5,'S_AC',[1]);
%
%		obj=struct('mu_a',[0.002],'mu_s',[10.0],'w',[70e6],'v',3e10/1.5);
%
%		l is an integer for the sum.
%
%		m is an integer for the sum and must be less than or equal to l.
%
%		theta is in radians measured from the positive z axis
%
%
%	  	Code Assumes Source is at -z,theta=pi,phi=0;
%  	Object is at z=0, x=0;, y=0;
%
%	External Calls: None
%
%	Internal Calls: (In order they appear in file)
%
%		function [A]=amatrix(D_out,k_out,r,D_in,k_in,r_s,S_AC,w,v,l);
%			% Calc Solution to Diffusion Equation with spherical Bessel Function
%
%		function an=k(v,w,mua,mus); 	% Calc k
%
%		function an=D(v,mus,mua);		% Calc d
%
%		function an=dh(l,m,beta);		% Calc derivative of spherical Hankel
%
%		function an=dj(l,beta);		% Calc derivative of spherical Bessel j
%
%		function an=sbj(l,beta)% Calc spherical Bessel j
%
%		function an=sbh(l,m,beta)% Calc spherical Hankel h
%
%		function an=Spherical_Harmonic(l,theta);	% Calc modified Legendre Poly.
%
%		Matlab only has normal bessel functions not spherical so 
%		I am using j(n,beta*r) =sqrt(pi/(2*beta*r)) * J(n+1/2,beta*r);
%
%   
%   Bugs: None known.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:46 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: aforward2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:46  rickg
%  Matlab Source
%
%
%	Revision: 1.5	Is it 'i' or is it 'j' and what is the difference
%	Revision: 1.4	Fixed h(1) to j+i*n which should be h(2)
%	Revision: 1.3	Fixed Derivative of Bessel functions and Modified Legendre functions
%	Revision: 1.2 	Made for passing cartesion coridinates
%	Revision: 1.1	Fixed calculation of Diffusivitiy 
%  Revision: 1.0 	Initial Setup
%	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Function

r=sqrt((r_obj.x-r_r.x)^2+(r_obj.y-r_r.y)^2+(r_obj.z-r_r.z)^2);
r_r_dot_r_s=(r_s.x-r_obj.x)*(r_obj.x-r_r.x)+(r_s.y-r_obj.y)*(r_obj.y-r_r.y)...
   +(r_s.z-r_obj.z)*(r_obj.z-r_r.z);
mag_r_r_and_r_s=sqrt((r_s.x-r_obj.x)^2+(r_s.y-r_obj.y)^2+(r_s.z-r_obj.z)^2)...
   *sqrt((r_obj.x-r_r.x)^2+(r_obj.y-r_r.y)^2+(r_obj.z-r_r.z)^2);
theta=acos(r_r_dot_r_s/mag_r_r_and_r_s);


D_out=D(back.v,back.mu_s,back.mu_a);
D_in = D(obj.v,obj.mu_s,obj.mu_a);
k_out=k(back.v,back.w,back.mu_a,back.mu_s);
k_in=k(obj.v,obj.w,obj.mu_a,obj.mu_s);

w=obj.w;
v=obj.v;
S_AC=back.S_AC;
z_s=r_r.z-r_obj.z;

phi_scatt=0;
for c=0:l
   A=amatrix(D_out,k_out,r_obj.radius,D_in,k_in,r_s,S_AC,w,v,c);
   phi_scatt=phi_scatt+...
      (A*sbj(c,k_out*r)+i*A*sby(c,k_out*r))*Spherical_Harmonic(c,theta);
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	Local Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A]=amatrix(D_out,k_out,r,D_in,k_in,r_s,S_AC,w,v,l);

x=k_out*r;
y=k_in*r;
s=k_out*r_s.z;

i=sqrt(-1);	%Force it in case I made a mistake somewhere.

coef1=i*v*S_AC*k_out*sbh(l,2,s)*conj(Spherical_Harmonic(0,pi))/D_out;
coef_nm1=D_out	*x	*dj(l,x)	 *sbj(l,y);
coef_nm2=D_in	*y	*sbj(l,x)	 *dj(l,y);
coef_dn1=D_out	*x	*dh(l,2,x) *sbj(l,y);
coef_dn2=D_in	*y	*sbh(l,2,x)*dj(l,y);

A=coef1*(coef_nm1-coef_nm2)/(coef_dn1-coef_dn2);

%
% Helper Functions (Local)
%
function an=k(v,w,mua,mus);
an=sqrt((-v*mua+i*w)/D(v,mus,mua));

function an=D(v,mus,mua);
an=v/(3*(mus+mua));

function an=dh(l,m,beta);
	an=sbh(l-1,m,beta)-((l+1)/beta)*sbh(l,m,beta);

function an=dj(l,beta);
   an=sbj(l-1,beta)-((l+1)/beta)*sbj(l,beta);

% Conversion from cylindrical to spherical bessel
function an=sbj(l,beta)
an=sqrt(pi/(2*beta))*besselj(l+1/2,beta);

% Conversion from cylindrical to spherical bessel
function an=sby(l,beta)
an=sqrt(pi/(2*beta))*bessely(l+1/2,beta);

% Conversion from cylindrical to spherical Hankel
function an=sbh(l,m,beta)
an=sqrt(pi/(2*beta))*besselh(l+1/2,m,beta);

% Conversion from Legendre to modified Legendre Polynomial
function an=Spherical_Harmonic(l,theta);
L=legendre(l,cos(theta));
an=L(1)*sqrt((2*l+1)/(4*pi)); 


