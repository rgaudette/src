%WAVEGRAD       Compute a gradient estimate using wavelet coefficients
%
%   grad = wavegrad(df_dx, df_dy, dx, dy)
%
%   grad        The gradient matrix.  This is complex and the same size as
%               df_dx and df_dy.
%
%   df_dx       The derivative estimate in the x direction.
%
%   df_dy       The derivative estimate in the y direction.
%
%   dx          OPTIONAL: The units in the x direction.
%
%   dy          OPTIONAL: The units in the y direction.
%
%
%   WAVEGRAD computes the gradient estimate using wavelet (which are assumed
%   to be estimates of the partial derivatives of the functions).
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:25 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: wavegrad.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:25  rickg
%  Matlab Source
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function grad = wavegrad(df_dx, df_dy, dx, dy)

if nargin < 4,
    dy = 1;
    if nargin < 3,
        dx = 1;
    end
end

%%
%%  Compute the spatial gradient
%%
grad = sqrt((df_dx ./ dx).^2 + (df_dy ./ dy).^2) .* ...
       exp(-j * atan2(df_dy ./ dy, df_dx ./ dx));
