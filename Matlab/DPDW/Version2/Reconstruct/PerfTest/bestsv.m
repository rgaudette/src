load ds780

F= [20:20:500];
nF =  length(F);

SV = zeros(288, nF);

for i = 1:nF
    f = F(i);
    f
    ds780.ModFreq = f;
    ds = genfwdmat(ds780);
    SV(:,i) = svd(ds.A);
end
