%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program reconstructs an image from its
% four wavelet images. (one step reconstruction).
%
% 	Program reconst1.m
% 	 by Wei Sun 
%
%	input variables:
%	  img: wavelet decomposition image
%
%	output variables:
%	  img: reconstructed image matrix.
%
%	decomposition:
%	 a -------> LL
%	 d1 ------> LH
%	 d2 ------> HL
%	 d3 ------> HH
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function img=old_reconst1(img,wf)

dim = size(img);
%
N=dim(1);
Nj=N/2;
ra=img(1:Nj,1:Nj);
rd1=img(1:Nj,(1+Nj):N);
rd2=img((1+Nj):N,1:Nj);
rd3=img((1+Nj):N,(1+Nj):N);
%
ra=ra';
rd1=rd1';
rd2=rd2';
rd3=rd3';
%
% Create QMF filters
%
hload6;
%
rtemp1=[];
rtemp2=[];
for I=1:Nj;
x=ra(I,:);
y=rd1(I,:);
w=rd2(I,:);
z=rd3(I,:);
%
xx=[x y].';
ww=[w z].';
xx=old_idwt1(h,xx);
ww=old_idwt1(h,ww);
yy=0;
zz=0;
rtemp1=[rtemp1 xx+yy];
rtemp2=[rtemp2 ww+zz];
end;
%
rtemp11=[];
rtemp22=[];
for I=1:N;
x=rtemp1(I,:);
y=rtemp2(I,:);
xx=[x y].';
xx=old_idwt1(h,xx);
yy=zeros(N,1);
rtemp11=[rtemp11 xx];
rtemp22=[rtemp22 yy];
end;
%
ra=(rtemp11+rtemp22);
img=ra';
