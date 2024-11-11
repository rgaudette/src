function y=nmlze(x)
%
%       NMLZE - nmlze(x) returns the vector x normalized so that it has
%               a maximum amplitude of unity.
y = x ./ max( max( abs(x) ) );
