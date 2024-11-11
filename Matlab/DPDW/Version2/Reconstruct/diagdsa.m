%DIAGDSA        Diagonalize the Slab Image data structure forward matrix
%
%   A = diagdsa(Amd);
%
%   A           The diagonalize matrix
%
%   Amd         The multidimensional A matrix.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:06 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: diagdsa.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:06  rickg
%  Matlab Source
%
%  Revision 1.0  1998/09/22 17:53:06  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function A = diagdsa(Amd)

[m n p ] = size(Amd);

if p == 2
A = [Amd(:,:,1) zeros(m, n)
     zeros(m, n) Amd(:,:,2) ];
end
if p == 3
A = [Amd(:,:,1) zeros(m, n) zeros(m, n)
     zeros(m, n) Amd(:,:,2) zeros(m, n)
     zeros(m, n)  zeros(m, n)Amd(:,:,3) ];
end
