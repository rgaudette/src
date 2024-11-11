%DIAMSEQ        Generate shaped 2D sequences.
%
%    Seq = diamseq(nFrames, Size, Step, Start)
%
%    nFrames    The number of frames to generate.
%
%    Size       The number of elements to side in each image.
%
%    Step       Amount to increase the diamond size for each image.
%
%    Start      The initial diamond size. 
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:21 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: diamseq.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:21  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:48:58  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Seq = diamseq(nFrames, Size, Step, Start)

if nargin < 4,
    Start = 1;
    if nargin < 3,
        Step = 1;
    end
end

Seq = zeros(Size*Size, nFrames);

for i=1:nFrames,
    tmp = diamond((i-1)*Step + Start, Size);
    Seq(:, i) = tmp(:);
end


