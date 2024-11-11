%IDWT1.m
%This program computes the inverse discrete wavelet transform of 
%a vector function w.
% This program will only do one step reconstruction. It assumes
% that input data only has one low-pass space and one wavelet space.
%
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%INPUTS:
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%H:the low-pass impulse response of the QMF realization of an 
%inverse discrete wavelet transform.
%W: contains the wavelet coefficients. 
%***************************************************************
%OUTPUTS:
%**************************************************************
%f:the desired timefunction 
%**************************************************************

function f = idwt1(h,w)
%
N = length(w);

M2 = length(h);
g = qmf(h);

% Do the reconstruction

M=N/2;
f=w(1:M);
% Undecimate

  f = [f';zeros(1,M)];
  d = [w((M+1):N)';zeros(1,M)];

% Periodize 

  f = [zeros(M2-1,1);f(:)];
  d = [zeros(M2-1,1);d(:)];
  for i = (M2-1):-1:1;
    f(i) = f(i+N);
    d(i) = d(i+N);

  end;

% Do filtering

  f = filter(h,1,f) + filter(g,1,d);
  f = f(M2:M2+N-1);

% added by weisun to rescale. easy to compare with Haar.
f=(2.^0.5)*f;
% end;

