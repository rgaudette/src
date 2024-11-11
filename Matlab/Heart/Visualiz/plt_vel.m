%PLT_VEL        Plot the velocity field of an array.
%
%   hArrows = plt_vel(Vel, szArray, tVel)
%
%   Vel         The velocity data.
%
%   szArray     The size of the array.
%
%   tVel        [OPTIONAL] If Vel contains data for all times, this vector
%               specifies the index to use for each lead.
%
%
%   
%
%   Calls: arrows2
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:52 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: plt_vel.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:52  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hArrows = plt_vel(Vel, szArray, tVel)

if nargin < 2,
    error('The array size must be specified');
end

[nLeads nSamps] = size(Vel);

%%
%%  Extract the specific velcoity estimate if neccessary
%%
if nSamps > 1,
    vField = zeros(szArray(1), szArray(2));
    for i = 1:nLeads,
        vField(i) = Vel(i, tVel(i));
    end
else
    vField = reshape(Vel, szArray(1), szArray(2));
end

hArrows = arrows2(vField);
axis([0 szArray(2)+1 0 szArray(1)+1]);
axis('image');
set(gca, 'ydir', 'reverse');
grid on
