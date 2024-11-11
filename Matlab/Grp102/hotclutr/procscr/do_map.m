bist_rcs
clg
subplot(211)
Abkm = Ab / 1e6;
c_struct = contour(x/1000, y/1000, Abkm, [5:5:80]);                      
clabel(c_struct, 'manual')
title('Lookout Mtn: Resolution Cell Area')
hold on 
plot([0 0], '*');
plot(TxPos/1000, 'x');
hold off
subplot(212)
c_struct = contour(x/1000, y/1000, SigmadB, [-120:6:-30]);
clabel(c_struct, 'manual')
title('Lookout Mountain: Minimum Sigma Naught Requirements')
hold on
plot([0 0], '*');
plot(TxPos/1000, 'x');
hold off
orient tall
