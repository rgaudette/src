function [y,level]=sll_cum(P)

P_dB=todb(abs(P));
Pmax=max(max(P_dB));
Pmin=min(min(P_dB));

npts = length( P_dB(:) );

level = Pmin : (Pmax-Pmin)/100 : Pmax;
nslices = length(level);

for k = 1 : nslices

   u = find( P_dB >= level(k) );
   y(k) = length(u) / npts;

end