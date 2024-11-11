function y = corrping(cpi, PhaseCorr)
y = cpi;
y(:,17:32) = cpi(:,17:32) * exp(j * PhaseCorr);
y(:,49:64) = cpi(:,49:64) * exp(j * PhaseCorr);
