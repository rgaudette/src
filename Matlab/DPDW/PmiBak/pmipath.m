%PMIPath        Add the necessary PMI directories to the MATLAB path.
function pmipath

%%
%%  PMI directories
%%
BasePath = 'C:\Src\Matlab\DPDW\PMI';
PMIPath = [ ...
        BasePath ';' ...
        BasePath '\Forward;' ...
        BasePath '\Reconstruct;' ...
        BasePath '\Reconstruct\PerfMeas;' ...
        BasePath '\Reconstruct\PerfTest;' ...        
        BasePath '\Reconstruct\Test;' ...
        BasePath '\Visualize;' ...
        BasePath '\UI;' ...
        BasePath '\Util;' ...
        BasePath '\Contrib;' ...
        BasePath '\Development' ];

path(path, PMIPath);