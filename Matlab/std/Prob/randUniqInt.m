%randUniqInt    Generate a sequence of unique random integers
%
%   seq = randUniqInt(n, range)
%
%   seq         The sequence of unique random integers
%
%   n           The number of integers to generate
%
%   range       The range (inclusive) of the sequence [imin imax]
%
%   nTrials     OPTIONAL: The maximum number of trials to attempt
%               (default: 1000).
%
%   randUniqInt will generate a sequence of unique random integers
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/12/15 00:53:30 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function seq = randUniqInt(n, range, nTrials)

if nargin < 3
  nTrials = 1000;
end

iRange = range(2) - range(1);
seq = round(rand(1) * iRange) + range(1);

while length(seq) < n && n < nTrials
   trial = round(rand(1) * iRange) + range(1);
   if ~ any(trial == seq)
     seq = [seq trial];
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: randUniqInt.m,v $
%  Revision 1.1  2004/12/15 00:53:30  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%