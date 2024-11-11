%WFC_QSPL       Wavelet Transform filter coefficients for the Quadratic Spline.
%
%   [Approx Detail] = wfc_qspl;
%
%   Ref: The Wavelet Transform applied QRS Complex Detection in ECG Analysis.

function [Approx, Detail] = wfc_qspl

Approx = [0.125 0.375 0.375 0.125];

Detail = [0 2 -2 0];
