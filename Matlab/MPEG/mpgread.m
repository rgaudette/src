%MPGREAD Read an MPEG encoded movie file.	
%	[M, map] = mpgread('filename', frames) reads the specifed
%	MPEG file and translates it into the movie M, and colormap map.
%	If a vector frames is specified, then only the frames specified
%	in this vector will be placed in M.  Otherwise, all frames will
%	be placed in M.
%
%	[R, G, B] = mpgread('filename, frames) will perform the same 
%	operation as above, except that the decoded MPEG frames will
%	be placed into the matrices R, G, B, where R contains the red
%	component for each frame, G, the green component, and B, the
%	blue component.
%
