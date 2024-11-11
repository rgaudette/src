%ORDEREVAL    Evaluate the performance with respect to order
%
ROI = [-3 3];
step = 0.01;
nBnd = 10;

vecOrder = [1:0.2:15];
nOrder = length(vecOrder);
mse = zeros(nOrder, 1);
peakerr = zeros(nOrder, 1);

%%
%%  Calculate k
%%
f = 200E6;
v = 3E10 / 1.37;
mu_sp = 10;
mu_a =  0.041;
D = v / (3 * (mu_sp + mu_a));
k = sqrt(-v * mu_a / D + j * 2 * pi * f / D);
    
for iOrder = 1:length(vecOrder)
    order = vecOrder(iOrder);
    [x J] = polybnd1(ROI, step, nBnd, order);
    x = x(:);
    %%
    %% Print out the region boundaries
    %%
%     fprintf('x min: %f\n', x(1));
%     fprintf('x max: %f\n', x(end));
%     fprintf('J(1): %d\n', J(1));
%     fprintf('x bnd1-: %f\n', x(J(1)-1)); 
%     fprintf('J(2): %d\n', J(2));
%     fprintf('x bnd2+: %f\n', x(J(2)+1)); 

    kvec = k * ones(size(x));
   
    %%
    %%  Create a point source at the origin
    %%
    q = zeros(size(x));
    [junk idxCtr] = min(abs(x));
    q(idxCtr) = 1 / step;

    %%
    %%  Compute the FDFD solution
    %%
    phi = hlm1d_vha(x, kvec, q);

    %%
    %%  Compute the Green's function solution
    %%
    green = -j./(2*kvec) .* exp(j*kvec .* abs(x-x(idxCtr)));

    figure(10)
    clf
    x_reg = x(J(1):J(2));
    phi_reg = phi(J(1):J(2));
    green_reg = green(J(1):J(2));

%     if all(real(kvec) == 0)
%         plot(x_reg, real(phi_reg), 'r')
%         hold on
%         plot(x_reg, real(green_reg), 'g-.');
%         axis([x(J(1)) x(J(2)) ...
%                 min(min(real(green_reg)),min(real(phi_reg))) ...
%                 max(max(real(green_reg)), max(real(phi_reg)))])
%     else
%         subplot(2,1,1)
%         plot(x_reg, real(phi_reg), 'r')
%         hold on
%         plot(x_reg, real(green_reg), 'g-.');
%         axis([x(J(1)) x(J(2)) ...
%                 min(min(real(green_reg)),min(real(phi_reg))) ...
%                 max(max(real(green_reg)), max(real(phi_reg)))])
%         subplot(2,1,2);
%         plot(x_reg, imag(phi_reg), 'r')
%         hold on
%         plot(x_reg, imag(green_reg), 'g-.');
%         axis([x(J(1)) x(J(2)) ...
%                 min(min(imag(green_reg)),min(imag(phi_reg))) ...
%                 max(max(imag(green_reg)), max(imag(phi_reg)))])
%     end
%     drawnow
        
    %%
    %%  Calculate the errors
    %%
    mse(iOrder) = mean(abs((green_reg - phi_reg)).^2);
    peakerr(iOrder) = max(abs(green_reg - phi_reg));
%     fprintf('Mean square error: %e\n', mse(iOrder));
%     fprintf('Peak value error: %e\n\n\n', peakerr(iOrder));
end
subplot(2,1,1)
set(gcf, 'DefaultAxesFontSize', 16);
semilogy(vecOrder, mse, 'linewidth', 3);
xlabel('Order');
ylabel('Mean Square Error');
title(['Error Perfomance vs. Order   Source Freq: ' int2str(f/1E6) ' MHz'])
subplot(2,1,2)
semilogy(vecOrder, peakerr, 'linewidth', 3);
xlabel('Order');
ylabel('Peak Value Error');

