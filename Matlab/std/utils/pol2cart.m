%POL2CART       Convert a pair of range and angle matricies to cartesian 
%               coordinates.
%
%    Z = pol2cart(Range, Theta)
%    [X Y] = pol2cart(Range, Theta)
%
%    Z          The complex representation of Range and Theta.
%
%    X, Y       The displacement in x and y coordinates of Range and Theta.
%
%    Range      A matrix specifying the ranges to convert.
%
%    Theta      A matrix specifying the angles to convert [radians].
%
%	    POL2CART converts a set of polar coordinates into cartesian
%    coordinates.  If there is only a single return argument the cartesian
%    coordinates returned are represented by complex pairs.  If there
%    are two return arguments the x and y values are returned seperately.
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: pol2cart.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.1   22 Mar 1994 10:24:40   rjg
%  Fixed nargout argument.
%  Updated help description.
%  
%     Rev 1.0   17 Mar 1994 17:37:20   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X, Y] = pol2cart(Range, Theta)

X = Range .* cos(Theta);
Y = Range .* sin(Theta);

if nargout == 1,
    X = X + j * Y;
end
