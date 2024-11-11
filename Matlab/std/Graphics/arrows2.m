%ARROWS2        Represent a complex function of 2D data.
%
%   hArrs = arrows2(fZ, Colors, Length)
%
%   hArrs       Handles to the arrow patches.
%
%   fZ          The complex function to be plotted.
%
%   Colors      [OPTIONAL]: A real matrix the same size as fZ that specifies
%               the color to use for each arrow.  This is used instead of the
%               amplitude of fZ.
%
%   Length      [OPTIONAL] : A real matrix the same size as fZ that specifies
%               the length to use for each arrow.  This is used instead of the
%               amplitude of fZ.
%
%   ARROWS2 displays a complex function of 2 dimensions using amplitude
%   and phase.  A triangular arrowhead for the phase of each point
%   and color for the amplitude.  The arrow heads are drawn using
%   MATLAB's patch function.  Note that the Y direction is also reversed so
%   that the orientation is the same as the matrix.
%
%
%   Calls: none.
%
%   Bugs: kind of slow, seem to be due to MATLABs patch function.
%        need to fix use of colors when specific values are supplied.
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: arrows2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.7  1997/08/13 22:10:21  rjg
%  Added scaling of patch length correction to account for only the ones
%  drawn.
%
%  Changed multply by ones to repmat call.
%
%  Revision 1.6  1997/04/08 18:36:28  rjg
%  Set EdgeColor to 'none' to speed up rendering
%
%  Revision 1.5  1997/04/08 17:42:28  rjg
%  Changed index evaluation to only draw patches that will be visible.
%
%  Revision 1.4  1996/09/18 00:46:25  rjg
%  Add another argument to control the length of the arrows.
%
%  Revision 1.3  1996/09/17 00:58:25  rjg
%  Added a second argument to provide for a different coloring than
%  the amplitude.
%
%  Revision 1.2  1996/09/16 19:26:56  rjg
%  Fixed row & column indexing.
%  Calling convention switched to complex data.
%
%  Revision 1.1  1996/09/16 15:21:38  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = arrows2(fZ, Colors, Length)

%%
%%
%%  Get the dimension of the functions
%%
[nImag nReal] = size(fZ);
fZ = fZ(:);

%%
%%  Generate a model arrow
%%  - top row is horizontal coordinates
%%  - bottom row is vertical coordinates
%%  - columns is the number of points in the patch
%%
Model = [-0.5 0.5 -0.5;
         -0.25 0   0.25];

[junk nModPoints] = size(Model);

%%
%%  Compute the angles & magnitudes of each element of the function
%%
Mag = abs(fZ);

%%
%%  Get indicies where magnitude is non-zero 
%%  Select only the values between the caxis if CLimMode is 'manual'
%%
if strcmp(get(gca, 'CLimMode'), 'auto')
    idxVisible = find(Mag ~= 0);
else
    Cax = caxis;
    idxVisible = find((Mag ~= 0) & (Mag > Cax(1)) & (Mag < Cax(2)));
end
if isempty(idxVisible)
    h = [];
    return
end


Mag = Mag(idxVisible);

MagNorm  = Mag ./ matmax(Mag);

if nargin < 2,
    Colors = Mag;
else    
    Colors = Colors(idxVisible);
end



%%
%%  Rotate an image of each arrow according to the phase at each sample point
%%
%%  - the rational operator is reversed becuse the ydir property is reversed
%%
re_fZ = real(fZ(idxVisible));
im_fZ = imag(fZ(idxVisible));

reArrow = [re_fZ./Mag im_fZ./Mag] * Model;
imArrow = [-1*im_fZ./Mag re_fZ./Mag] * Model;

%%
%%  If the length argument is supplied scale the arrows.
%%
if nargin > 2,
    Length = Length(idxVisible);
    Length = repmat(Length (:) ./ matmax(abs(Length)), 1, nModPoints);
    reArrow = reArrow .* Length;
    imArrow = imArrow .* Length;
end

%%
%%  Offset each arrow according to its sample position
%%
[rePos imPos] = meshgrid([1:nReal], [1:nImag]);
rePos = repmat(rePos(idxVisible)', nModPoints, 1);
imPos = repmat(imPos(idxVisible)', nModPoints, 1);

%%
%%  Draw the arrows as patch objects
%%
%%  Ugly work-around for Matlab bug with 3 patches
%%
if length(Colors) == 3,
    h = patch(rePos + reArrow', imPos + imArrow', Colors(:), ...
        'EdgeColor', 'none');
else
    h = patch(rePos + reArrow', imPos + imArrow', Colors(:)', ...
        'EdgeColor', 'none');
end
set(gca, 'ydir', 'reverse');
