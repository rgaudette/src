%CPMEASDATA     Copy measured data from one Slab Image data structure to another
%
%   res = cpmeasdata(src, measdata)
%
%   res         The resultant slab image data structure.
%
%   src         The source data structure for all but the measured data.
%
%   measdata    The Slab Image data structure conatining the measured data.
%
%
%   CPMEASDATA copies the measured data from one Slab Image data structure
%   to another while leaving all of the other fields intact.  This allows
%   for computing the forward data using one model/geometry and inverting
%   with another.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:44 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cpmeasdata.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:44  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = cpmeasdata(src, measdata)

res = src;

res.Phi_Total = measdata.Phi_Total;
res.Phi_Inc = measdata.Phi_Inc;
res.Phi_Scat = measdata.Phi_Scat;
res.Phi_ScatN = measdata.Phi_ScatN;
res.flgNeedFullSVD = 1;
res.flgNeedEconSVD = 1;
res.flgUpdNoise = 1;
res.SrcSNRflag = measdata.SrcSNRflag;
res.SrcSNR = measdata.SrcSNR;
res.DetSNRflag = measdata.DetSNRflag;
res.DetSNR = measdata.DetSNR;
res.ScatSNRflag = measdata.ScatSNRflag;
res.ScatSNR = measdata.ScatSNR;
res.VecNormSNRflag = measdata.VecNormSNRflag;
res.VecNormSNR = measdata.VecNormSNR;
