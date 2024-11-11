%fftbech  FFT benchmark
%
%  elapsed_time = fftbench(data_size, iterations)
%
%  Execute iterations data_size^3 3D FFTs and return the elapsed time to
%  compute the FFTs


function elapsed_time = fftbench(data_size, iterations)
if nargin < 1
    data_size = [128 128 128];
end
if nargin < 2
    iterations = 10;
end

if length(data_size) == 1
    data_size = [data_size, data_size, data_size];
end
    
x = randn(data_size);

st = clock;
for n = 1:iterations
  X = fftn(x);
end
elapsed_time  = etime(clock, st);
data_size(1)
iterations
elapsed_time 
%fprint('%d 3D FFT %d Interations elapsed time: %f\n', data_size(1), iterations, elapsed_time );
return
