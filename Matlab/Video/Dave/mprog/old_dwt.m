%DWT1.M
%THIS PROGRAM COMPUTES THE WAVELET COEFFICIENTS OF A SIGNAL VIA 
%THE FILTER BANK EFFICIENT COMPUTING METHOD.
% This program will only do one step decomposition.
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%INPUTS:
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%H:IS THE LOW-PASS FILTER IMPULSE RESPONSE (OR COEFFICIENTS)
%F:IS THE SIGNAL FUNCTION OR VECTOR (a row vector)
%**************************************************************
%OUTPUTS:
%W: IS THE VECTOR OF COEFFICIENTS ARRANGED AS  [H^k f; GH^(k-1)f;
%GH^(k-2)f;...; GHf; Gf] 
%**************************************************************
%FUNCTION W = DWT1(h,f)
function w = old_dwt(h,f)

N = length(f);

% Construct a flipped "g" out of a conjugate mirror filter from h

M2 = length(h);
g(2:2:M2) = h(2:2:M2);
g(1:2:M2-1) = -h(1:2:M2-1);

% Now flip h to use with filter for convolution.

h = h(M2:-1:1);

w = zeros(N,1);

% Periodize the signal to avoid edge effects
  for i = 1:(M2-1);
    f(i+N) = f(i);
  end;

% filter do convolution of g and f;
% if g=[1 2], f=[2 3 4], filter gives [2 7 10]
  d = filter(g,1,f);
  f = filter(h,1,f);

% Decimate (for orthogonalization) and store 
  i = M2:2:(N+M2-2);
  w(N/2+1:N) = d(i);

% Next level

  f = f(i);

w(1:(N/2)) = f;

% added by weisun to rescale. easy to compare with Haar.
% i.e. Same decompositions for Haar and Daube should have
% similar grey level ranges.
% Note: if h=[2.^(-0.5) 2.^(-0.5)], it is Haar wavelet.

w=w/(2.^0.5);

% end;

