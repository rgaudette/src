%QUIV4          Plot 4 quiver plots.
%
subplot(2,2,1)

[nrF ncF] = size(F);
quiver(flipud(F), zeros(size(F)));
axis([1 nrF 1 ncF]);
xlabel('X')
ylabel('Y')
title('Input signal');

subplot(2,2,2);
quiver(flipud(real(D1)), flipud(imag(D1)));
axis([1 nrF 1 ncF])
xlabel('X')
ylabel('Y')
title('D1')

subplot(2,2,3)
quiver(flipud(real(D2)), flipud(imag(D2)));
axis([1 nrF 1 ncF])
xlabel('X')
ylabel('Y')
title('D2');

subplot(2,2,4)
quiver(flipud(real(A)), flipud(imag(A)));
axis([1 nrF 1 ncF])
xlabel('X')
ylabel('Y')
title('A');
