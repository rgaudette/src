clf

plot(c_float(:,1), c_float(:,4), 'c');
hold on
plot(blas_float(:,1), blas_float(:,4), 'r');
plot(ipp_float(:,1), ipp_float(:,4), 'g');
plot(java_float(:,1), java_float(:,3), 'b');
plot(matlab_double(:,1), matlab_double(:,3), 'm');
grid on;
axis([100 300 0 350])
xlabel('Matrix Size')
ylabel('MFLOPS/Sec')
title('Matrix Multiply 4 Byte Floating Point Performance')
blas_mean = mean(blas_float(:,4));
ipp_mean = mean(ipp_float(:,4));
c_mean = mean(c_float(:,4));
java_mean = mean(java_float(:,3));
matlab_mean = mean(matlab_double(:,3));

legend(['C ' num2str(c_mean) ' MFLOPS/Sec  '], ...
       ['BLAS ' num2str(blas_mean) ' MFLOPS/Sec  '], ...
       ['IPP ' num2str(ipp_mean) ' MFLOPS/Sec  '], ...
       ['Java ' num2str(java_mean) ' MFLOPS/Sec  '], ...
       ['MATLAB (double)' num2str(matlab_mean) ' MFLOPS/Sec  ']);
