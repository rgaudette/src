function [axout,h1,h2]=myplotyy(x1,y1,x2,y2,fun1,fun2)
%PLOTYY Graphs with y tick labels on the left and right.
%   PLOTYY(X1,Y1,X2,Y2) plots Y1 versus X1 with y-axis labeling
%   on the left and plots Y2 versus X2 with y-axis labeling on
%   the right.
%
%   PLOTYY(X1,Y1,X2,Y2,FUN) uses the plotting function specified by 
%   the string FUN instead of PLOT to produce each plot.  FUN
%   should be a plotting function like 'plot','semilogx','semilogy',
%   'loglog','stem', etc. that accepts the syntax H = FUN(X,Y).
%
%   PLOTYY(X1,Y1,X2,Y2,FUN1,FUN2) uses FUN1(X1,Y1) to plot the data for
%   the left axes and FUN2(X1,Y1) to plot the data for the right axes.
%
%   [AX,H1,H2] = PLOTYY(...) returns the handles of the two axes created in
%   AX and the handles of the graphics objects from each plot in H1
%   and H2. AX(1) is the left axes and AX(2) is the right axes.  
%
%   See also PLOT.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.1.1.1 $  $Date: 2004/01/03 08:27:34 $

if nargin<4, error('Not enough input arguments.'); end
if nargin<5, fun1 = 'plot'; end
if nargin<6, fun2 = fun1; end

hold_state = ishold;
co = get(gcf,'defaultaxescolororder');

% Plot first plot
ax(1) = newplot;
set(gcf,'nextplot','add')
h1 = feval(fun1,x1,y1, 'linewidth', 2);
set(ax(1),'box','on')
xlim1 = get(ax(1),'xlim');
ylim1 = get(ax(1),'ylim');


% Try to produce different colored lines on each plot by
% shifting the colororder by the number of different colors
% in the first plot.
%colors = get(findobj(h1,'type','line'),{'color'});
%if ~isempty(colors),
%  colors = unique(cat(1,colors{:}),'rows');
%  n = size(colors,1);
%  % Set the axis color to match the single colored line
%  if n==1, set(ax(1),'ycolor',colors), end
%  set(gcf,'defaultaxescolororder',co([n+1:end 1:n],:))
%end

% Plot second plot
ax(2) = axes('position',get(ax(1),'position'));
h2 = feval(fun2,x2,y2, '-.', 'linewidth', 2);
set(ax(2),'YAxisLocation','right','color','none', ...
          'xgrid','off','ygrid','off','box','off');
xlim2 = get(ax(2),'xlim');
ylim2 = get(ax(2),'ylim');

% Check to see if the second plot also has one colored line
colors = get(findobj(h2,'type','line'),{'color'});
if ~isempty(colors),
  colors = unique(cat(1,colors{:}),'rows');
  n = size(colors,1);
  if n==1, set(ax(2),'ycolor',colors), end
end

islog = strcmp(get(ax(1),'yscale'),'log');

if islog, ylim1 = log10(ylim1); ylim2 = log10(ylim2); end

% Find bestscale that produces the same number of y-ticks for both
% the left and the right.
[low,high,ticks] = bestscale(ylim1(1),ylim1(2),ylim2(1),ylim2(2),islog);

if ~isempty(low)
    if islog,
      yticks1 = logsp(low(1),high(1),ticks(1));
      yticks2 = logsp(low(2),high(2),ticks(2));
      low = 10.^low;
      high = 10.^high;
      ylim1 = 10.^ylim1;
      ylim2 = 10.^ylim2;
    else
      yticks1 = linspace(low(1),high(1),ticks(1));
      yticks2 = linspace(low(2),high(2),ticks(2));
    end

    % Set ticks on both plots the same
    set(ax(1),'ylim',[low(1) high(1)],'ytick',yticks1);
    set(ax(2),'ylim',[low(2) high(2)],'ytick',yticks2);
    set(ax,'xlim',[min(xlim1(1),xlim2(1)) max(xlim1(2),xlim2(2))])
else
    % Use the default automatic scales and turn off the box so we
    % don't get double tick marks on each side.  We'll still get
    % the grid from the left axes though (if it is on).
    set(ax,'box','off')
end

% create DeleteProxy objects (an invisible text object in
% the first axes) so that the other axes will be deleted
% properly.
DeleteProxy(1) = text('parent',ax(1),'visible','off',...
                      'tag','PlotyyDeleteProxy',...
                      'handlevisibility','off',...
        'deletefcn','eval(''delete(get(gcbo,''''userdata''''))'','''')');
DeleteProxy(2) = text('parent',ax(2),'visible','off',...
                       'tag','PlotyyDeleteProxy',...
                       'handlevisibility','off',...
         'deletefcn','eval(''delete(get(gcbo,''''userdata''''))'','''')');
set(DeleteProxy(1),'userdata',ax(2));
set(DeleteProxy(2),'userdata',DeleteProxy(1));

if ~hold_state, hold off, end

% Reset colororder
set(gcf,'defaultaxescolororder',co,'currentaxes',ax(1))

if nargout>0, axout = ax; end



%---------------------------------------------------
function [low,high,ticks] = bestscale(umin,umax,vmin,vmax,islog)
%BESTSCALE Returns parameters for "best" yy scale.

penalty = 0.02;

% Determine the good scales
[ulow,uhigh,uticks] = goodscales(umin,umax);
[vlow,vhigh,vticks] = goodscales(vmin,vmax);

% Find good scales where the number of ticks match
[u,v] = meshgrid(uticks,vticks);
[j,i] = find(u==v);

if islog % Filter out the cases where power of ten's don't match
  for k=length(i):-1:1
    utest = logsp(ulow(i(k)),uhigh(i(k)),uticks(i(k)));
    vtest = logsp(vlow(j(k)),vhigh(j(k)),vticks(j(k)));
    upot = abs(log10(utest)-round(log10(utest))) < 10*eps*log10(utest);
    vpot = abs(log10(vtest)-round(log10(vtest))) < 10*eps*log10(vtest);
    if ~isequal(upot,vpot),
       i(k) = [];
       j(k) = [];
    end
  end
end

if ~isempty(i)
  udelta = umax-umin;
  vdelta = vmax-vmin;
  ufit = ((uhigh(i)-ulow(i)) - udelta)./(uhigh(i)-ulow(i));
  vfit = ((vhigh(j)-vlow(j)) - vdelta)./(vhigh(j)-vlow(j));

  fit = ufit + vfit + penalty*(max(uticks(i)-6,1)).^2;

  % Choose base fit
  k = find(fit == min(fit)); k=k(1);
  low = [ulow(i(k)) vlow(j(k))];
  high = [uhigh(i(k)) vhigh(j(k))];
  ticks = [uticks(i(k)) vticks(j(k))];
else
  % Return empty to signal calling routine that we weren't able to
  % find matching scales.
  low = [];
  high = [];
  ticks = [];
end



%------------------------------------------------------------
function [low,high,ticks] = goodscales(xmin,xmax)
%GOODSCALES Returns parameters for "good" scales.
%
% [LOW,HIGH,TICKS] = GOODSCALES(XMIN,XMAX) returns lower and upper
% axis limits (LOW and HIGH) that span the interval (XMIN,XMAX) 
% with "nice" tick spacing.  The number of major axis ticks is 
% also returned in TICKS.

BestDelta = [ .1 .2 .5 1 2 5 10 20 50 ];
penalty = 0.02;

% Compute xmin, xmax if matrices passed.
if length(xmin) > 1, xmin = min(xmin(:)); end
if length(xmax) > 1, xmax = max(xmax(:)); end
if xmin==xmax, low=xmin; high=xmax+1; ticks = 1; return, end

% Compute fit error including penalty on too many ticks
Xdelta = xmax-xmin;
delta = 10.^(round(log10(Xdelta)-1))*BestDelta;
high = delta.*ceil(xmax./delta);
low = delta.*floor(xmin./delta);
ticks = round((high-low)./delta)+1;



%---------------------------------------------
function  y = logsp(low,high,n)
%LOGSP Generate nice ticks for log plots
%   LOGSP produces linear ramps between 10^k values.

y = linspace(low,high,n);

k = find(abs(y-round(y))<=10*eps*max(y));
dk = diff(k);
p = find(dk > 1);

y = 10.^y;

for i=1:length(p)
  r = linspace(0,1,dk(p(i))+1)*y(k(p(i)+1));
  y(k(p(i))+1:k(p(i)+1)-1) = r(2:end-1);
end
