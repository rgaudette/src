%parseFSCorr    Parse the output of David's Fourier Shell Correlation
%               program
%
%   [freq FSC npoints phaseResidual] = parseFSCorr(filename)

function [freq FSC npoints phaseResidual] = parseFSCorr(filename)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: parseFSCorr.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

[fid msg] = fopen(filename, 'r');

if fid == -1
  error(msg);
end

flgFoundFSCOut = 0;
idx = 1;
line = fgetl(fid);
while ischar(line)
  if flgFoundFSCOut
    vals = sscanf(line, '%f');
    freq(idx) = vals(1);
    FSC(idx) = vals(4);
    npoints(idx) = vals(2);
    phaseResidual(idx) = vals(3);
    
    idx = idx + 1;
  end
  if ~isempty(strfind(line, 'Radius  # pts  PhaseRes'))
    flgFoundFSCOut = 1;
  end
  line = fgetl(fid);
end
fclose(fid);
