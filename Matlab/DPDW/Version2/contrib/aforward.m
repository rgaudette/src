function [phi_scatt]=aforward(r_s,r_r,r_obj,back,obj,l,m);
%AFORWARD            Analytic Spherical Bessel Function Solution
%							for single spherical scatter at origin
%
% Structures Passed:
%
%		r_s=struct('r',[0],'theta',[0],'phi',[0]);
%
%		r_r=struct('r',[0],'theta',[0],'phi',[0]);
%
%		r_obj=struct('r',[0],'theta',[0],'phi',[0],'radius',[1]);
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
%	  	Code Assumes Source is at r,theta=pi,phi=0;
%  	Object is at z=0, x=0;, y=0;
%
%	External Calls: None
%
%	Internal Calls: (In order they appear in file)
%
%		function A=amatrix(D_out,k_out,r,D_in,k_in,r_s,S_AC,w,v,l);
%			% Calc Solution to Diffusion Equation with spherical Bessel Function
%
%		function an=k(v,w,mua,mus); 	% Calc k
%
%		function an=D(v,mus,mua);		% Calc d
%
%		function an=diffh(l,beta);		% Calc derivative of spherical Hankel
%
%		function an=diffj(l,beta);		% Calc derivative of spherical Bessel j
%
%		function an=sp_besselj(l,beta)% Calc spherical Bessel j
%
%		function an=sp_besselh(l,beta)% Calc spherical Hankel h
%
%		function an=mod_Y(l,theta);	% Calc modified Legendre Poly.
%
%		function an=mod2_Y(l,m,theta);% Calc modified Legendre Func.
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
%  $Date: 2004/01/03 08:26:01 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: aforward.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:01  rickg
%  Matlab Source
%
%
%	Revision: 1.1	Fixed calculation of Diffusivitiy 
%  Revision: 1.0 	Initial Setup
%	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Function

D_out=D(back.v,back.mu_s,back.mu_a);
D_in = D(obj.v,obj.mu_s,obj.mu_a);
k_out=k(back.v,back.w,back.mu_a,back.mu_s);
k_in=k(obj.v,obj.w,obj.mu_a,obj.mu_s);

w=obj.w;
v=obj.v;
S_AC=back.S_AC;

phi_scatt=0;
for c=0:l
   [A]=amatrix(D_out,k_out,r_obj.radius,D_in,k_in,r_s,S_AC,w,v,c);
   phi_scatt=phi_scatt+A*sp_besselh(c,k_out*r_r.r)*mod_Y(c,r_r.theta);
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	Local Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A]=amatrix(D_out,k_out,r,D_in,k_in,r_s,S_AC,w,v,l);

x=k_out*r;
y=k_in*r;
i=sqrt(-1);	%Force it incase I made a mistake somewhere.

coef1=-i*v*(S_AC*k_out/D_out)*sp_besselh(l,k_out*r_s.r)*mod_Y(0,r_s.theta);
coef_nm1=D_out*x*diffj(l,x)*sp_besselj(l,y);
coef_nm2=D_in*y*sp_besselj(l,x)*diffj(l,y);
coef_dn1=D_out*x*diffh(l,x)*sp_besselj(l,y);
coef_dn2=D_in*y*sp_besselh(l,x)*diffj(l,y);

A=coef1*(coef_nm1-coef_nm2)/(coef_dn1-coef_dn2);

%
% Helper Functions (Local)
%
function an=k(v,w,mua,mus);
an=sqrt((-v*mua+i*w)/D(v,mus,mua));

function an=D(v,mus,mua);
an=v/(3*(mus+mua));


function an=diffh(l,beta);
if (l==0)
   an=-i*sp_besselh(1,beta);
else
   an=(i/(2*l+1))*(l*sp_besselh(l-1,beta)-(l+1)*sp_besselh(l+1,beta));
end

function an=diffj(l,beta);
if (l==0)
   an=-i*sp_besselj(1,beta);
else
   an=(i/(2*l+1))*(l*sp_besselj(l-1,beta)-(l+1)*sp_besselj(l+1,beta));
end

function an=sp_besselj(l,beta)
% Conversion from cylindrical to spherical bessel
an=sqrt(pi/(2*beta))*besselj(l+1/2,beta);

function an=sp_besselh(l,beta)
% Conversion from cylindrical to spherical bessel
an=sqrt(pi/(2*beta))*besselh(l+1/2,1,beta);

function an=mod_Y(l,theta);
% Conversion from Legendre to modified Legendre Polynomial
L=legendre(l,cos(theta));
an=L(1)*(2*(l+1)/(4*pi)); 

function an=mod2_Y(l,m,theta);
% Conversion from Legendre to modified Legendre Polynomial
L=legendre(l,cos(theta));
an=L(m+1)*(2*(l+1)/(4*pi)); 

