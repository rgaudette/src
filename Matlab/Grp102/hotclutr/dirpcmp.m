format compact
disp('Raw channel power')
db(mean(max(v2p(cpi1(:,[2:14])))))
db(mean(max(v2p(cpi2(:,[2:14])))))
db(mean(max(v2p(cpi3(:,[2:14])))))
db(mean(max(v2p(cpi4(:,[2:14])))))

disp('Dipole channel power')
db(mean(max(v2p(cpi1(:,1)))))
db(mean(max(v2p(cpi2(:,1)))))
db(mean(max(v2p(cpi3(:,1)))))
db(mean(max(v2p(cpi4(:,1)))))

hcg_proc

disp('Mean peak beamformer power')
db(mean(max(v2p(CPIrp_bf))))

disp('Mean peak phase corrector power')
db(mean(max(v2p(CPIrp_pc))))

disp('Peak coherent integrator power')
db(mean(max(v2p(CPIrp_ci))))

clf
[val idx] = max(v2p(CPIrp_bf(:,1)));
freq = [-32:31] / 64 / 3302e-6;
plot(freq, fftshift(db(v2p(fft(CPIrp_bf(idx+2,:) .* hamming(64).')))))
xlabel('Frequency (Hz)')
ylabel('Amplitude (dB)')
axis([-150 150 100 160])
tag