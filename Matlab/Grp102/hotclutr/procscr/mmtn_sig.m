%MMTN_SIG_13V       Socorro peak 4 frequency sigma0 computation for 13 uSec
%                   PCW vertical.
%

load MMtn4348PCW13V
Sigma4348 = matSigma0;

load MMtn4350PCW13V
Sigma4350 = matSigma0;

load MMtn4352PCW13V
Sigma4352 = matSigma0;

load MMtn4354PCW13V
Sigma4354 = matSigma0;

mSigma0 = mfsigma0(Sigma4348, Sigma4350, Sigma4352, Sigma4354);

save MMtn4FreqPCW13V