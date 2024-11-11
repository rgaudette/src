%rbRecon        Reconstruction technique radio button control function.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:15 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rbRecon.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:15  rickg
%  Matlab Source
%
%  Revision 1.3  1998/07/30 20:01:30  rjg
%  Removed SIdefines codes, uses string now.
%  Added TCG
%  Restructured case statement so that everything is deselected first.
%
%  Revision 1.2  1998/06/03 16:42:57  rjg
%  Uses SIdefines codes
%  Added MTSVD handling
%  Added ART handling
%
%  Revision 1.1  1998/04/28 20:29:34  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbRecon(strAlg)

UIHandles = get(gcf, 'UserData');

%%
%%  Deselect everything
%%
set(UIHandles.BackProj, 'value', 0);
set(UIHandles.ART, 'value', 0);
set(UIHandles.ARTnIter, 'Enable', 'off');
set(UIHandles.ARTnIter, 'BackgroundColor', [0.65 0.65 0.65]);
set(UIHandles.SIRT, 'value', 0);
set(UIHandles.SIRTnIter, 'Enable', 'off');
set(UIHandles.SIRTnIter, 'BackgroundColor', [0.65 0.65 0.65]);
set(UIHandles.MinNorm, 'value', 0);
set(UIHandles.TSVD, 'value', 0);
set(UIHandles.TSVDnSV, 'Enable', 'off');
set(UIHandles.TSVDnSV, 'BackgroundColor', [.65 .65 .65]);
set(UIHandles.MTSVD, 'value', 0);
set(UIHandles.MTSVDnSV, 'Enable', 'off');
set(UIHandles.MTSVDnSV, 'BackgroundColor', [.65 .65 .65]);
set(UIHandles.MTSVDLambda, 'Enable', 'off');
set(UIHandles.MTSVDLambda, 'BackgroundColor', [.65 .65 .65]);
set(UIHandles.TCG, 'value', 0);
set(UIHandles.TCGnIter, 'Enable', 'off');
set(UIHandles.TCGnIter, 'BackgroundColor', [.65 .65 .65]);

%%
%%  Select the requested alg
%%
switch strAlg
case 'Back Projection'
    set(UIHandles.BackProj, 'value', 1);

case 'ART'
    set(UIHandles.ART, 'value', 1);
    set(UIHandles.ARTnIter, 'Enable', 'on');
    set(UIHandles.ARTnIter, 'BackgroundColor', [1 1 1]);

case 'SIRT'
    set(UIHandles.SIRT, 'value', 1);
    set(UIHandles.SIRTnIter, 'Enable', 'on');
    set(UIHandles.SIRTnIter, 'BackgroundColor', [1 1 1]);

case 'Min. Norm'
    set(UIHandles.MinNorm, 'value', 1);
    
case 'TSVD'
    set(UIHandles.TSVD, 'value', 1);
    set(UIHandles.TSVDnSV, 'Enable', 'on');
    set(UIHandles.TSVDnSV, 'BackgroundColor', [1 1 1]);

case 'MTSVD'
    set(UIHandles.MTSVD, 'value', 1);
    set(UIHandles.MTSVDnSV, 'Enable', 'on');
    set(UIHandles.MTSVDnSV, 'BackgroundColor', [1 1 1]);
    set(UIHandles.MTSVDLambda, 'Enable', 'on');
    set(UIHandles.MTSVDLambda, 'BackgroundColor', [1 1 1]);

case 'TCG'
    set(UIHandles.TCG, 'value', 1);
    set(UIHandles.TCGnIter, 'Enable', 'on');
    set(UIHandles.TCGnIter, 'BackgroundColor', [1 1 1]);

otherwise
    error('Unimplemented reconstruction technique');
end
