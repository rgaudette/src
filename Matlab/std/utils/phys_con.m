%PHYS_CON       Physical constants definintion file.
%
%    phys_con
%
%
%        PHYS_CON is script file that will place a number of physical
%    constants in the current workspace.  There are also a number of
%    conversion factors available. Use TYPE to view the contents of this
%    file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: phys_con.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.2   25 Mar 1994 10:14:26   rjg
%  Added earth's gravitational constant.
%  
%     Rev 1.1   22 Mar 1994 10:35:06   rjg
%  Updated help description.
%  
%     Rev 1.0   17 Mar 1994 17:27:06   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C = 299792458;                % Free Space EM propagation speed (m/s).
E = 8.854E-12;                % Charge of an electron (coloumbs). 
Ga = 9.80665;                 % Earth's gravitational constant at surface m/s^2
K = 1.381E-23;                % Boltzman constant
Mu = 4.0E-7 * pi;             % Magnetic field constant

%%
%%    Conversion factors
%%
m2ft   = 3.280839899501;      % meters to feet
m2nmi  = 5.39956803456E-4;    % meters to nautical miles
ft2nmi = 1.64578833693E-4;    % feet to nautical miles
