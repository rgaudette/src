%print_stack    Display a stack trace structure (from lasterror)
%
%  print_stack(stack)

function print_stack(stack)
n_levels = length(stack);
for level = n_levels:-1:1
  fprintf('Function : %s\n', stack(level).name);
  fprintf('File: %s\n', stack(level).file);
  fprintf('Line: %d\n', stack(level).line);
end