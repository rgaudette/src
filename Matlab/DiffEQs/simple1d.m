%SIMPLE1D       A simple finite difference differential EQ implementation
%

%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:23:59 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: simple1d.m,v $
%  Revision 1.1.1.1  2004/01/03 08:23:59  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function template(parm)
flgDebug = 1;

LeftBoundary = 1;
RightBoundary = 0;
nPoints = 500;
Coeff = .01
XStep = 1;
hStep = 2 * XStep;
xMax = (nPoints - 1) * XStep;
XVec = linspace(0, xMax, nPoints);
YVec = zeros(nPoints,1);
YNew = zeros(nPoints,1);
ErrVec = zeros(nPoints-2, 1);
dYVec = zeros(nPoints-2, 1);
maxDiff = 1E-4;

%%
%%  Initialize the Y vector
%%
YVec(1) = LeftBoundary;
YVec(nPoints) = RightBoundary;
YVec(2:nPoints-1) = rand(nPoints-2,1);
if flgDebug
    plot(XVec, YVec)
    drawnow;
end

%%
%%  Compute the initial error function
%%
ErrVec = YVec(2:nPoints-1) - Coeff./hStep * centdiff(YVec);

while any(ErrVec > maxDiff)

    YVec(2:nPoints-1) = YVec(2:nPoints-1) - 1/3 * ...
        (ErrVec ...
        - hStep/Coeff * [0 ;ErrVec(1:nPoints-3)] ...
        + hStep/Coeff * [ErrVec(2:nPoints-2); 0] );

    %%
    %%  Compute the new estimate dy/dx
    %%
    ErrVec = YVec(2:nPoints-1) - Coeff./hStep * centdiff(YVec);

    
    if flgDebug
        plot(XVec, YVec)
        drawnow;
    end
end
