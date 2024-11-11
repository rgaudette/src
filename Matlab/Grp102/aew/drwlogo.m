%
% DRWLOGO - Function to draw LL logo
%
%   Invocation:
%
%	drwlogo(color,filename)
%
%	color =    string to specify logo color
%		   'w' = white,  'c' = cyan, 'r' = red, etc.
%	filename = string to be placed at botom of logo
%		   to identify file (OPTIONAL)


function drwlogo(color,filename)

theta=0:.01:2*pi;
x=.6*sin(4*theta);
y=.6*sin(3*theta);



l=[ -1.00   1.00
    -0.90   0.85
    -0.90  -0.85
    -1.00  -1.00
     0.55  -1.00
     0.75  -0.70
     0.55  -0.80
    -0.65  -0.80
    -0.65   0.85
    -0.55   1.00
    -1.00   1.00 ];


plot( x,y,color , -.1+l(:,1),l(:,2),color , .1-l(:,1),-l(:,2),color )

h=gca;

set( h , 'Visible' , 'off' );
set( h , 'AspectRatio' , [1 .8] ); 

hh = get( h , 'Children' );

for k=1:3
%  set( hh(k) , 'LineWidth' , 1 );
end

if nargin==2
    hx=text(0,-1.4,filename);
    set(hx,'FontSize',8)
    set(hx,'HorizontalAlignment','center')
    set(hx,'VerticalAlignment','middle')
end
