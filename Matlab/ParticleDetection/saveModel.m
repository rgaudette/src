%saveModel A simple function to save a Nx3 matrix as an IMOD model

function saveModel(fileName, matrix)
textFile = [fileName '.txt'];
save(textFile, '-ascii', 'matrix')
command = ['point2model ' textFile ' ' fileName '.mod'];
[exitValue output] = system(command);
if exitValue ~= 0
  output
  error(['Error: ' command]);
end
