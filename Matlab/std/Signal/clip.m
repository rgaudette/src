%CLIP           Hard limit a real array.
%
%    Y = clip(X, Min, Max)
%
%    Y          The resultant array.
%
%    X          The array to be clipped.
%
%    Min        The minimum value to be forced on the array.  All elements
%               less than this value will be set to this value.
%
%    Max        OPTIONAL: The maximum value to be forced on the array.  If
%               given any element greater than this value will be set to
%               this value.
%
%        CLIP replaces elements less than and optionally greater than the
%    limits given by the values of Min and Max.
%
%    Calls: none.
%
%    Bugs: Currently only works on real arrays (how on complex, amplitude
%        or real and imag individually).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: clip.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:09:51  rjg
%  Initial revision
%
%  
%     Rev 1.1   21 Mar 1994 17:34:38   rjg
%  Used automatic indexing to handle find and replace.
%  Added more comments and help description.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = clip(x, Min, Max)

%%
%%    Find values of X less than Min and replace them with min.
%%
idxLow = find(x < Min);
x(idxLow)  = Min * ones(size(idxLow));

%%
%%    Find values of X greater than Max (if given) and replace them with Max.
%%
if nargin > 2,
    idxHigh = find(x > Max);
    x(idxHigh)  = Max * ones(size(idxHigh));
end
