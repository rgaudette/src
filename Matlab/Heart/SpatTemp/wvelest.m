%WVELEST        Wave front velocity estimate.
%
%   [velest grad]= wvelest(df_dt, df_dx, df_dy, dt, dx, dy)
%
%   wvelest     The velocity estimate using complex values.
%
%   df_dt       The derivative estimate of the function w.r.t. time
%
%   df_dx       The derivative estimate of the function w.r.t. the x dir.
%
%   df_dy       The derivative estimate of the function w.r.t. the y dir
%
%   dt          [OPTIONAL] The temporal sampling interval.
%
%   dx          [OPTIONAL] The horizontal sampling interval.
%
%   dy          [OPTIONAL] The vertical sampling interval.
%   
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:43 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: wvelest.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:43  rickg
%  Matlab Source
%
%  Revision 1.2  1996/09/22 21:37:57  rjg
%  Velocity is now computed where the gradient is large instead of at fiducial
%  times.
%
%  Revision 1.1  1996/09/10 21:25:35  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [velest, grad, detGrad, detTempAct, detTempRec] = ...
    wvelest(df_dt, df_dx, df_dy, dt, dx, dy)

if nargin < 6,
    dy = 1;
    if nargin < 5,
        dx = 1;
        if nargin < 4;
            dt = 1;
        end
    end
end

%%
%%  Initialization and preallocations.
%%
[nLeads nSamples] = size(df_dt);
velest = zeros(nLeads, nSamples);
detGrad = zeros(nLeads, nSamples);
detTempAct = zeros(nLeads, nSamples);
detTempRec = zeros(nLeads, nSamples);

%%
%%  Compute the spatial gradient
%%
grad = sqrt((df_dx ./ dx).^2 + (df_dy ./ dy).^2) .* ...
       exp(-j * atan2(df_dy ./ dy, df_dx ./ dx));

%%
%%  Compute velocity estimates at places/time where the gradient and 
%%  temporal derivative is greater than the thresholds
%%
gradWindow = 20;
gradBlank = 20;
gradThresh = 1.5;
tempWindowAct = 20;
tempBlankAct = 10;
tempThreshAct = 1.5;
tempWindowRec = 30;
tempBlankRec = 25;
tempThreshRec = 1.5;

for idxLead = 1:nLeads,
    [junk detGrad(idxLead,:)] = meanthr(abs(grad(idxLead,:)), ...
                                    gradBlank, gradWindow, gradThresh);
    [junk detTempAct(idxLead,:)] = meanthr(-1*df_dt(idxLead,:), ....
                            tempBlankAct, tempWindowAct, tempThreshAct);
    [junk detTempRec(idxLead,:)] = meanthr(df_dt(idxLead,:), ....
                            tempBlankRec, tempWindowRec, tempThreshRec);
end

idxCompVel = find((detGrad & detTempAct) | (detGrad & detTempRec));
velest(idxCompVel) = -1 * (df_dt(idxCompVel) ./ dt) ./ grad(idxCompVel);

%Threshold = 0.1 * matmax(abs(grad));
%for idxSample = 1:nSamples,
%    Threshold = 0.25 * abs(grad(:, idxSample));
%    idx = (abs(grad(:, idxSample)) > Threshold);
%
%    thrshGrad = 0.1 * max(abs(grad(:,idxSample)));
%    thrshTemp = 0.25 * max(df_dt(:,idxSample));
%    idx = (abs(grad(:,idxSample )) > thrshGrad) & ...
%          (df_dt(:, idxSample) > thrshTemp);
%
%    velest(idx, idxSample) = -1 * ...
%        (df_dt(idx, idxSample) ./ dt) ./ grad(idx, idxSample);
%
%end

