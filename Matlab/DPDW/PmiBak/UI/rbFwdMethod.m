%rbFwMethod     Forward method radio button selection.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:41 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rbFwdMethod.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbFwdMethod(value)
UIHandles = get(gcf, 'UserData');

switch value

case 'Matlab Variable'
    set(UIHandles.Fwd_Born, 'value', 0);
    set(UIHandles.Fwd_Order, 'Enable', 'off');
    set(UIHandles.Fwd_Rytov, 'value', 0);    
    set(UIHandles.Fwd_FDFD, 'value', 0);
    set(UIHandles.Fwd_FiniteElem, 'value', 0);
    set(UIHandles.Fwd_Spherical, 'value', 0);

    set(UIHandles.Fwd_MatlabVar, 'value', 1);
    set(UIHandles.Fwd_MatlabVarName, 'Enable', 'on');


case 'Born'
    set(UIHandles.Fwd_MatlabVar, 'value', 0);
    set(UIHandles.Fwd_MatlabVarName, 'Enable', 'off');
    set(UIHandles.Fwd_Rytov, 'value', 0);
    set(UIHandles.Fwd_FDFD, 'value', 0);
    set(UIHandles.Fwd_FiniteElem, 'value', 0);
    set(UIHandles.Fwd_Spherical, 'value', 0);

    set(UIHandles.Fwd_Born, 'value', 1);
    set(UIHandles.Fwd_Order, 'Enable', 'on');

case 'Rytov'
    set(UIHandles.Fwd_MatlabVar, 'value', 0);
    set(UIHandles.Fwd_MatlabVarName, 'Enable', 'off');
    set(UIHandles.Fwd_Born, 'value', 0);
    set(UIHandles.Fwd_FDFD, 'value', 0);
    set(UIHandles.Fwd_FiniteElem, 'value', 0);
    set(UIHandles.Fwd_Spherical, 'value', 0);

    set(UIHandles.Fwd_Rytov, 'value', 1);
    set(UIHandles.Fwd_Order, 'Enable', 'on');

case 'Spherical'
    set(UIHandles.Fwd_MatlabVar, 'value', 0);
    set(UIHandles.Fwd_MatlabVarName, 'Enable', 'off');
    set(UIHandles.Fwd_Born, 'value', 0);
    set(UIHandles.Fwd_Rytov, 'value', 0);
    set(UIHandles.Fwd_FDFD, 'value', 0);
    set(UIHandles.Fwd_FiniteElem, 'value', 0);

    set(UIHandles.Fwd_Order, 'Enable', 'on');
    set(UIHandles.Fwd_Spherical, 'value', 1);

case 'FDFD'
    set(UIHandles.Fwd_MatlabVar, 'value', 0);
    set(UIHandles.Fwd_MatlabVarName, 'Enable', 'off');
    set(UIHandles.Fwd_MatlabVarName, 'Enable', 'off');
    set(UIHandles.Fwd_Born, 'value', 0);
    set(UIHandles.Fwd_Order, 'Enable', 'off');
    set(UIHandles.Fwd_Rytov, 'value', 0);
    set(UIHandles.Fwd_FiniteElem, 'value', 0);
    set(UIHandles.Fwd_Spherical, 'value', 0);

    set(UIHandles.Fwd_FDFD, 'value', 1);


case 'FEM'
    set(UIHandles.Fwd_MatlabVar, 'value', 0);
    set(UIHandles.Fwd_MatlabVarName, 'Enable', 'off');
    set(UIHandles.Fwd_Born, 'value', 0);
    set(UIHandles.Fwd_Order, 'Enable', 'off');
    set(UIHandles.Fwd_Rytov, 'value', 0);
    set(UIHandles.Fwd_FDFD, 'value', 0);
    set(UIHandles.Fwd_Spherical, 'value', 0);

    set(UIHandles.Fwd_FiniteElem, 'value', 1);

end
