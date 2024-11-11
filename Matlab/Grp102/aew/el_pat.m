%
%  EL_PAT:  function to compute normalized limacon element pattern
%
%     Invocation:
%
%	function y=el_pat(theta,lc)
%
%	theta = matrix of angles (deg) at which to evaluate element pattern
%	lc  =   Limacon factor for element pattern:
%	           0 = cosine pattern
%	           1 = cardiod
%		  >1 gives backlobe
%
%


function y=el_pat(theta,lc)

y=nmlze( cos(torad(theta))+lc );