%MKVG           Function to convert MATLAB Plot to LL Viewgraph with Logo
%
%    Invocation:
%
%	mkvg(ttl,filename,icolor)
%
%	ttl = title string
%	filename = file name for .ps output file
%       icolor = 1 to save as .psc, 0 to save as .ps
%       iprt =1 to send to printer
%

function mkvg(ttl,filename,icolor,iprt)

if nargin==1
 isave=0;
 filename='';
else
 isave=1;
end
if exist('icolor')~=1
 icolor=0;
end
if exist('iprt')~=1
 iprt=0;
end


color_order = [ 0 0 1		% Blue
                0 1 0		% Green
                1 0 0		% Red
                0 1 1		% Cyan
                1 0 1 ];	% Magenta

[ncolors,three]=size(color_order);

hf = gcf;
set(hf,'PaperOrientation','landscape')
set(hf,'PaperPosition',[0 0 11 8.5])

h_axis=gca;

set( h_axis , 'Position' , [ .25 .2 .5 .5 ] );   % Position Plot on Page
set( h_axis, 'FontSize', 15 );			 % Set font size for x,y,z axis

h_x = get( h_axis , 'Xlabel');			 % Set font size for x axis label
set( h_x, 'FontSize', 16 );


h_y = get( h_axis , 'Ylabel');			 % Set font size for y axis label
set( h_y, 'FontSize', 16 );


h_c = get( h_axis , 'Children' );		 % Make lines thick, and change
nchild=length(h_c);				 % colors so that they show up
for k=1:nchild					 % on the Tektronix printer.
 chtype=get(h_c(k),'Type');
 if chtype=='text'
  set(h_c(k),'FontSize',14)
 elseif chtype=='line'
  set(h_c(k),'LineWidth',1)
 end
end


X=get(h_axis,'Xlim');			         % Re Draw Frame (Thick)
Y=get(h_axis,'Ylim');
h_frame=line( [ X(1) X(2) X(2) X(1) X(1) ] , [ Y(1) Y(1) Y(2) Y(2) Y(1) ]);
set(h_frame,'LineWidth',3')
set(h_frame,'Color',[1 1 1])


%
% Now add new axes to draw title
%


h2=axes( 'Position' , [.1 .75 .8 .05 ] );
set( h2 , 'Visible' , 'off' );
h_ttl = get( h2 , 'Title' );
set( h_ttl , 'FontSize' , 24 );
set( h_ttl , 'FontWeight' , 'Bold' );

if nargin>=1
   set( h_ttl , 'String' , ttl );
end

%
% Add Logo
%

h3=axes( 'Position' , [.84 .1 .065 .065 ] );
drwlogo('w',filename)

%
% create .ps output file
%

if isave==1
 if icolor==1
  string = [ 'print -dpsc ' filename ];
 else
  string = [ 'print -dps ' filename ];
 end
 eval(string)
end

set(hf,'PaperOrientation','portrait')

return



