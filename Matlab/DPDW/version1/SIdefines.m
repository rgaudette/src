%SIDefines      Enumerations and defines for the slab imaging program.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:58 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: SIdefines.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:58  rickg
%  Matlab Source
%
%  Revision 1.1  1998/06/03 16:16:20  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%  Medium boundary
%%
SI.BndExtrap   = 0;
SI.BndInfinite = 1;


%%
%%  Data source
%%
SI.DSrcMatVar = 0;
SI.DSrcPMI    = 1;
SI.DSrcBorn1  = 2;
SI.DSrcRytov  = 3;
SI.DSrcFDFD   = 4;
SI.DSrcFEM    = 5;

%%
%%  Reconstruction technique
%%
SI.RAlgBackProj = 0;
SI.RAlgART      = 1;
SI.RAlgSIRT     = 2;
SI.RAlgMinNorm  = 3;
SI.RAlgTSVD     = 4;
SI.RAlgMTSVD    = 5;
SI.RAlgDualWL   = 6;

%%
%%  Visualization technique
%%
SI.VTImage   = 0;
SI.VTContour = 1;

%%
%%  Visualization colormap
%%
SI.CMBgyor   = 0;
SI.CMGrey = 1;

%%
%%  Visualization range
%%
SI.CRAuto = 0;
SI.CRFixed = 1;
