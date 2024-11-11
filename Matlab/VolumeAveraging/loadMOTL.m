function motl = loadMOTL(filename)
global PRINT_ID
if PRINT_ID
    fprintf('$Id: loadMOTL.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

motl = getfield(tom_emread(filename), 'Value');
