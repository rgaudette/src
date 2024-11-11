%POLEZERO       Plot the poles & zeros of a ratio of polynomials.
%
%   polezero(b,a,flgUC)

function polezero(b,a,flgUC)

if nargin < 3,
    flgUC = 1;
end

zeros = roots(b);
poles = roots(a);

plot(real(zeros), imag(zeros), 'or');
hold on
plot(real(poles), imag(poles), 'xg');
if flgUC,
    circle = exp(j*2*pi*[0:500]/500);
    plot(real(circle), imag(circle));
end
hold off

