%DB             Convert a linear sequence to dB by applying 10 * log10().
%
%    dBSeq = db(linSeq)
%
%
%        This function implements the formula,
% 
%    dB = 10 * log10(Seq);
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: db.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:11:09  rjg
%  Initial revision
%
%  
%     Rev 1.1   22 Mar 1994 09:09:02   rjg
%  Updated help description.
%  
%     Rev 1.0   01 Sep 1993 15:20:06   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dBSeq = db(linSeq);
dBSeq = 10*log10(linSeq);
