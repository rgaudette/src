%SHAD_MAP	Generate a shadow map from an elevation map a an observation
%		position.
%
%    vis = shad_map(xdist, ydist, dma, ObsrvPos, TowerHieght)
%
%    vis	A 0,1 matrix correspsnding to dma.  A 0 signifies a shadowed
%		point on the map.
%
%    xdist	The x distance values corresponding to the columns of map
%		[kilometers].
%
%    ydist	The y distance values corresponding to the rows of map
%		[kilometers].
%
%    dma	The altitude map array [meters].
%
%    ObsrvPos	The observation position wrt to the map origin [kilometers].
%
%    TowerHeight   OPTIONAL: The antenna tower height [meters],
%                  default = 0.
%
%
%    Calls: none

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: shad_map.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:32  rickg
%  Matlab Source
%
%  
%     Rev 1.1   10 May 1993 14:46:12   rjg
%  Added ability to enter tower height, cleaned up Obsrv Position reporting.
%  
%     Rev 1.0   31 Mar 1993 15:12:48   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vis = shad_map(xdist, ydist, dma, ObsrvPos, TowerHeight)

if nargin < 5,
    TowerHeight = 0;
end

xdist = xdist * 1000;
ydist = ydist * 1000;
ObsrvPos = ObsrvPos * 1000;

x_del = xdist(2) - xdist(1);
y_del = ydist(2) - ydist(1);
AspectRatio = x_del / y_del;
NXPos = length(xdist);
NYPos = length(ydist);

ydist = ydist(:);

Position =   ones(size(ydist)) * xdist + j * ydist * ones(size(xdist));

ObsrvRel = Position - ObsrvPos;

[junk ObsrvIndex ] = min(abs(ObsrvRel(:)));
ObsrvColIndex = fix((ObsrvIndex - 1) / NYPos) + 1;
ObsrvRowIndex =  rem(ObsrvIndex, NYPos);
Altitude = dma(ObsrvRowIndex, ObsrvColIndex);
ObsrvHeight = Altitude + TowerHeight;
disp(['Altitude : ' num2str(Altitude) ' meters  + ' num2str(TowerHeight) ...
     ' meters for the tower.']);

ObsrvPos = Position(ObsrvRowIndex, ObsrvColIndex)
ObsrvRel = Position - ObsrvPos;

ObsrvDeltaH = dma - ObsrvHeight;
ObsrvRange = abs(ObsrvRel);
ObsrvTheta = angle(ObsrvRel);
theta_depr = atan(ObsrvDeltaH ./ ObsrvRange);
cv_theta_depr = theta_depr(:);
vis = zeros(NYPos, NXPos);

for xi = 1:NXPos,
    for yi = 1:NYPos,
	%%
	%%    If n x samples greater than number y sample in los
	%%  use x as step
	%%
	if xi == ObsrvColIndex | abs(xi - ObsrvColIndex) == 1,
	    if yi == ObsrvRowIndex | abs(yi-ObsrvRowIndex) == 1,
		idx_y = yi;
	    elseif yi > ObsrvRowIndex,
		idx_y = [ObsrvRowIndex+1: yi-1];
	    else
		idx_y = [yi+1 :ObsrvRowIndex-1];
	    end
	    idx_x = xi * ones(size(idx_y));

	elseif abs(xi - ObsrvColIndex) > abs(yi - ObsrvRowIndex),
	    if xi > ObsrvColIndex,
		idx_x = [ObsrvColIndex+1 : xi-1];
	    else
		idx_x = [xi+1 : ObsrvColIndex-1];
	    end
	    idx_y = round(ObsrvRowIndex + ...
		x_del * (idx_x - ObsrvColIndex) * ...
		tan(ObsrvTheta(yi, xi)) / y_del );
	else
	    if yi == ObsrvRowIndex,
		disp('Should not be here')
		pause
	    elseif yi > ObsrvRowIndex,
		idx_y = [ObsrvRowIndex+1 : yi-1];
	    else
		idx_y = [yi+1 : ObsrvRowIndex-1];
	    end
	    idx_x = round(ObsrvColIndex + ...
		 y_del * (idx_y - ObsrvRowIndex) / ...
		tan(ObsrvTheta(yi, xi)) / x_del );

	end

	%%
	%%    Compute depression angle for LOS.
	%%

	long_ind = (idx_x - 1) * NYPos + idx_y;

	LosDeprAngle = cv_theta_depr(long_ind);

	worst = max(LosDeprAngle);

	ShadowHeight = tan(worst) * ObsrvRange(yi, xi);

	vis(yi, xi) =  dma(yi, xi) - ObsrvHeight >= ShadowHeight;
    end
end
