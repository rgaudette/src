function tideal(fname,np)

eval(fname)
eval(['load ' fname '.cov -mat'])

if nargin==2
  npulse=np;
  dsll=1;	% (biniomial weighting)
else
  dsll=-50;	% (-50 dB Chebyshev taper)
end

size=npulse*nels;

s=sv_stap(nels,npulse,0,-35,.5,dsll,d,f0);

R=Rc(1:size,1:size)+Rn(1:size,1:size);
Rinv=inv(R);

w=Rinv*s;

%pat_st(w,nels,d,f0,-90:90,-.5:.01:.5,1,'Space-Time Adapted Pattern',fname);


%figure(2)
dop=(-.5:.01:.5);
sinr_loss=loss(Rinv,nels,npulse,0,-35,dop,dsll,d,f0);
%plot(dop,sinr_loss)


%figure(3)
e=flipud(sort(10*log10(abs(eig(R)))));
%plot(e)


 eval(['save ' fname '.res R Rinv s w e dop sinr_loss'])
%eval(['save ' fname '.rs3 R Rinv s w e dop sinr_loss'])
