function dpdwv2
rmdpdwpaths
%%
%%  DPDW directories
%%
DPDWPath = [ ...
        'c:\src\matlab\DPDW;' ...
        'c:\src\matlab\DPDW\Forward;' ...
        'c:\src\matlab\DPDW\Reconstruct;' ...
        'c:\src\matlab\DPDW\Reconstruct\PerfMeas;' ...
        'c:\src\matlab\DPDW\Reconstruct\PerfTest;' ...        
        'c:\src\matlab\DPDW\Reconstruct\Test;' ...
        'c:\src\matlab\DPDW\Visualize;' ...
        'c:\src\matlab\DPDW\SlabImg;' ...
        'c:\src\matlab\DPDW\Contrib;' ...
        'c:\src\matlab\DPDW\Development;' ]
path(path, DPDWPath);