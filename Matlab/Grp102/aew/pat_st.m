%  PAT_ST - Function to compute space-time pattern
%
%     Invocation:
%
%	p=pat_st(w,nels,d,f,az,fd,win,ttl,subttl,filename)
%
%	w = space-time weight vector
%	nels = number of elements
%	d = inter-element spacing (m)
%	f = radar frequency (MHz)
%	az = vector of azimuths at which to evaluate pattern (deg)
%	fd = vector of dopplers at which to evaluate pattern (normalized)
%
%       OPTIONAL PARAMETERS  (Specify only if pattern is to be plotted)
%
%	win = MATLAB figure window for plot
%	ttl = title string
%	subttl = subtitle string
%	filename = string containing filename of output .eps file
%		   (if not specified, no output file will be created)
%
%	OUTPUT
%
%	p = computed pattern (complex)

function p=pat_st(w,nels,d,f,az,fd,win,ttl,subttl,filename)

ndelays=length(w)/nels;

ww=reshape(w,nels,ndelays);		% Azimuth Factor
for m=1:ndelays
  A(m,:)=spattern(ww(:,m),az,d,f).';
end

theta=2*pi*fd.';			% Doppler Factor
M=(1:ndelays);
D=exp(-j*theta*(M-1));

p=D*A;					% Azimuth-Doppler Pattern

if nargin>=7

  p_max=max(max(abs(p)));
  floor=.000001*p_max; 
  pp=abs(p)+floor;
  pp_min=min(min(pp)); 
  ppp=pp/pp_min;
  ppp_db=todb(ppp);
  z=fix(ppp_db)+1;
  zmax=max(max(z));

  figure(win)
  clf

  set(win,'PaperOrientation','landscape')
  set(win,'PaperPosition',[0 0 11 8.5])

  h1=axes('Position',[ .225 .2 .4 .5 ]);
  image(az,fd,z);				
  xlabel('Azimuth (deg)')
  ylabel('Normalized Doppler')
  set( h1, 'FontSize', 15 );			% Set font size for x,y axis  
  h_x = get( h1 , 'Xlabel');			% Set font size for x axis label
  set( h_x, 'FontSize', 16 );
  h_y = get( h1 , 'Ylabel');			% Set font size for y axis label
  set( h_y, 'FontSize', 16 );
  if nargin>=9					% Add Subtitle and set font size
    title(subttl)
    h_t = get(h1,'Title');
    set(h_t,'FontSize',10)
  end
  set(h1,'YDir' , 'normal')
  colormap(jet(zmax+1))

  h2=axes('Position', [ .775, .2, .05, .5]);
  image(0:1 , (-(zmax-1):0)' ,  (1:zmax)' )
  ylabel('Normalized Gain (dB)')
  set( h2, 'FontSize', 15 );			% Set font size for x,y axis  
  h_x = get( h2 , 'Xlabel');			% Set font size for x axis label
  set( h_x, 'FontSize', 16 );
  h_y = get( h2 , 'Ylabel');			% Set font size for y axis label
  set( h_y, 'FontSize', 16 );
  set(h2,'YDir' , 'normal')
  set(h2,'XTickLabels',' ')


  %
  % Now add new axes to draw title
  %


  h3=axes( 'Position' , [.1 .75 .8 .05 ] );
  set( h3 , 'Visible' , 'off' );
  h_ttl = get( h3 , 'Title' );
  set( h_ttl , 'FontSize' , 20 );
  %set( h_ttl , 'FontWeight' , 'Bold' );
  set( h_ttl , 'String' , ttl );


  %
  % Add Logo
  %

  h4=axes( 'Position' , [.84 .1 .065 .065 ] );
  if nargin==10
    drwlogo('w',filename)
  else
    drwlogo('w')
  end
 
  figure(win)


%
% create .eps output file
%

if nargin==10
  string = [ 'print -depsc ' filename ];
  eval(string)
end

end
