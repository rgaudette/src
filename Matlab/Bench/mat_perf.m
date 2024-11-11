%MAT_PERF    Measure MATLAB performance
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:23:56 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mat_perf.m,v $
%  Revision 1.1.1.1  2004/01/03 08:23:56  rickg
%  Matlab Source
%
%  
%     Rev 1.0   17 Mar 1994 17:18:44   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [TotTime, MultTime, CreatTime, TotFlops, MultFlops, CreatFlops] = ...
    mat_perf(Rows, Columns, Iterations);

StartTime = clock;
StartFlops = flops;

a = crandn(Rows, Columns);
b = crandn(Rows, Columns);

CreatTime = clock;
CreatFlops = flops;

for i = 1:Iterations,
    c = a * b;
end

MultTime = clock;
MultFlops = flops;

TotTime = etime(MultTime, StartTime);
MultTime = etime(MultTime, CreatTime);
CreatTime = etime(CreatTime, StartTime);

TotFlops =  MultFlops - StartFlops;
MultFlops = MultFlops - CreatFlops;
CreatFlops = CreatFlops - StartFlops;

fprintf('Matrix size:                  %d x %d\n', Rows, Columns);
fprintf('Number of interations:        %d\n\n', Iterations);

fprintf('Matrix creation time:         %f seconds\n', CreatTime);
fprintf('Matrix multiplication time:   %f seconds\n', MultTime);
fprintf('Total processing time:        %f seconds\n\n', TotTime);

fprintf('Matrix creation flops:        %d flops\n', CreatFlops);
fprintf('Matrix multiplication flops:  %d flops\n', MultFlops);
fprintf('Total processing flops:       %d flops\n\n', TotFlops);

fprintf('Creation flops/sec:           %f Mflops/sec\n', CreatFlops/CreatTime/1e6);
fprintf('Multiplication flops/sec:     %f Mflops/sec\n', MultFlops / MultTime/1e6);
fprintf('Total flops/sec:              %f Mflops/sec\n', TotFlops / TotTime/1e6);
