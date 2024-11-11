%NEWPATH        Interactively setup the MATLAB search path.
%
%    newpath
%
%
%        NEWPATH presents a menu of the available path setups and allows
%    the user to set a new search path.
%
%    Calls: none
%
%    Bugs: slow to startup and does not know about path changes.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: newpath.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.2   22 Mar 1994 10:29:06   rjg
%  Modified help description.
%  
%     Rev 1.1   04 Aug 1993 00:05:36   rjg
%  Added new path's and changed menu.
%  
%     Rev 1.0   05 Mar 1993 11:18:44   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function newpath
if computer == 'HP700',
    Base = '/users/rjg';
else
    Base = '/home/ipx1/rjg';
end
BasicPath = [	'/usr/local/matlab/toolbox/matlab/general:' ...
		'/usr/local/matlab/toolbox/matlab/ops:' ...
		'/usr/local/matlab/toolbox/matlab/lang:' ...
		'/usr/local/matlab/toolbox/matlab/elmat:' ...
		'/usr/local/matlab/toolbox/matlab/specmat:' ...
		'/usr/local/matlab/toolbox/matlab/elfun:' ...
		'/usr/local/matlab/toolbox/matlab/specfun:' ...
		'/usr/local/matlab/toolbox/matlab/matfun:' ...
		'/usr/local/matlab/toolbox/matlab/datafun:' ...
		'/usr/local/matlab/toolbox/matlab/polyfun:' ...
		'/usr/local/matlab/toolbox/matlab/funfun:' ...
		'/usr/local/matlab/toolbox/matlab/sparfun:' ...
		'/usr/local/matlab/toolbox/matlab/plotxy:' ...
		'/usr/local/matlab/toolbox/matlab/plotxyz:' ...
		'/usr/local/matlab/toolbox/matlab/graphics:' ...
		'/usr/local/matlab/toolbox/matlab/color:' ...
		'/usr/local/matlab/toolbox/matlab/sounds:' ...
		'/usr/local/matlab/toolbox/matlab/strfun:' ...
		'/usr/local/matlab/toolbox/matlab/iofun:' ...
		'/usr/local/matlab/toolbox/matlab/demos:' ...
		'/usr/local/matlab/toolbox/local:' ...
		'/usr/local/matlab/toolbox/signal:' ];

MyLib = [	Base '/Matlab:'];

MyPMA = [	Base '/Matlab/PMA:'];

HotClutter = [	Base '/Matlab/HotClutter:' ];

IsoDoppler = [	Base '/Matlab/IsoDoppler:' ];

JimPMA = [	'/home/jim/jw/matlab/pmajw/main:' ...
		'/home/jim/jw/matlab/pmajw/sdproc:' ...
		'/home/jim/jw/matlab/pmajw/utils:' ...
		'/home/jim/jw/matlab/pmajw/userio:' ...
		'/home/jim/jw/matlab/pmajw/work:' ];

PVSW = [	'/home/ipx1/rjg/Matlab/Pvsw:'];

Select = menu('Select a new search path', ...
	'My lib, My PMA', ...
	'My lib, Jim''s PMA', ...
	'Jim''s PMA,  My lib', ...
	'My Lib, Hot Clutter', ...
	'My Lib, IsoDoppler', ...
	'My Lib, Group 108 PVSW');
close
if Select == 1,
    path([MyLib MyPMA BasicPath]);
end

if Select == 2,
    path([MyLib JimPMA BasicPath]);
end

if Select == 3,
    path([JimPMA MyLib BasicPath]);
end

if Select == 4,
    path([MyLib HotClutter  BasicPath]);
end

if Select == 5,
    path([MyLib IsoDoppler  BasicPath]);
end

if Select == 6,
    path([MyLib PVSW BasicPath]);
end
