%rbDataSource   Data source selector radio button control function.
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
%  $Log: rbDataSource.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:15  rickg
%  Matlab Source
%
%  Revision 1.3  1998/07/30 20:00:06  rjg
%  Removed SIdefines codes, uses string now.
%
%  Revision 1.2  1998/06/03 16:41:49  rjg
%  Uses SIdefines codes
%  Added handling for PMI execution
%
%  Revision 1.1  1998/04/28 20:28:55  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rbDataSource(value)
UIHandles = get(gcf, 'UserData');

switch value

case 'Matlab Variable'
    set(UIHandles.PMI, 'value', 0);
    set(UIHandles.PMIFileName, 'Enable', 'off');
    set(UIHandles.PMIFileName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.Born1, 'value', 0);
    set(UIHandles.FDFD, 'value', 0);
    set(UIHandles.Rytov, 'value', 0);    
    set(UIHandles.FiniteElem, 'value', 0);

    set(UIHandles.MatlabVar, 'value', 1);
    set(UIHandles.MatlabVarName, 'Enable', 'on');
    set(UIHandles.MatlabVarName, 'BackgroundColor', [1 1 1]);    


case 'PMI Script'
    set(UIHandles.MatlabVar, 'value', 0);
    set(UIHandles.MatlabVarName, 'Enable', 'off');
    set(UIHandles.MatlabVarName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.Born1, 'value', 0);
    set(UIHandles.FDFD, 'value', 0);
    set(UIHandles.FiniteElem, 'value', 0);

    set(UIHandles.PMI, 'value', 1);
    set(UIHandles.PMIFileName, 'Enable', 'On');
    set(UIHandles.PMIFileName, 'BackgroundColor', [1 1 1]);


case 'Born-1'
    set(UIHandles.MatlabVar, 'value', 0);
    set(UIHandles.MatlabVarName, 'Enable', 'off');
    set(UIHandles.MatlabVarName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.PMI, 'value', 0);
    set(UIHandles.PMIFileName, 'Enable', 'off');
    set(UIHandles.PMIFileName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.FDFD, 'value', 0);
    set(UIHandles.Rytov, 'value', 0);
    set(UIHandles.FiniteElem, 'value', 0);

    set(UIHandles.Born1, 'value', 1);


case 'Rytov-1'
    set(UIHandles.MatlabVar, 'value', 0);
    set(UIHandles.MatlabVarName, 'Enable', 'off');
    set(UIHandles.MatlabVarName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.PMI, 'value', 0);
    set(UIHandles.PMIFileName, 'Enable', 'off');
    set(UIHandles.PMIFileName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.FDFD, 'value', 0);
    set(UIHandles.Born1, 'value', 0);
    set(UIHandles.FiniteElem, 'value', 0);

    set(UIHandles.Rytov, 'value', 1);


case 'FDFD'
    set(UIHandles.MatlabVar, 'value', 0);
    set(UIHandles.MatlabVarName, 'Enable', 'off');
    set(UIHandles.MatlabVarName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.PMI, 'value', 0);
    set(UIHandles.PMIFileName, 'Enable', 'off');
    set(UIHandles.PMIFileName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.Born1, 'value', 0);
    set(UIHandles.FiniteElem, 'value', 0);

    set(UIHandles.FDFD, 'value', 1);


case 'FEM'
    set(UIHandles.MatlabVar, 'value', 0);
    set(UIHandles.MatlabVarName, 'Enable', 'off');
    set(UIHandles.MatlabVarName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.PMI, 'value', 0);
    set(UIHandles.PMIFileName, 'Enable', 'off');
    set(UIHandles.PMIFileName, 'BackgroundColor', [0.65 0.65 0.65]);
    set(UIHandles.Born1, 'value', 0);
    set(UIHandles.FDFD, 'value', 0);

    set(UIHandles.FiniteElem, 'value', 1);

end
