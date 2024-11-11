%SILABEL        Label a Slab Image plot with current parameters.
%
%   silabel(hFigPlot, hFigSI);
%
%   hFigPlot    OPTIONAL: The figure handle for the plot.
%
%   hFigSI      OPTIONAL: The handle of the figure containing the Slab Image
%               structure.
%
%   Calls: getall
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:58 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: silabel.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:58  rickg
%  Matlab Source
%
%  Revision 1.3  1998/08/05 15:32:11  rjg
%  Enhanced reporting of reconstruction parameters and multple noise 
%  methods.
%
%  Revision 1.2  1998/08/05 15:22:45  rjg
%  Removed describe function, not needed with string description of 
%  reconstruction methods.
%
%  Revision 1.1  1998/06/18 15:11:01  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function silabel(hFigPlot, hFigSI);

if nargin < 2
    figure(1);
else
    figure(hFigSI);
end
stSlabImg = getall;

if nargin < 1
    figure(2);
else
    figure(hFigPlot);
end

hax = axes('position', [0 0 1 1]);
set(hax, 'visible', 'off');
string1 = ['X Step: ' num2str(stSlabImg.XStep) ' cm,  ' ...
        'Y Step: ' num2str(stSlabImg.YStep) ' cm,  ' ...
        'Z Step: ' num2str(stSlabImg.ZStep) ' cm,  ' ...
        'Source X: ' vec2str(stSlabImg.SrcXPos) '  ' ...
        'Y: ' vec2str(stSlabImg.SrcYPos) ' cm,  ' ...
        'Det. X: ' vec2str(stSlabImg.DetXPos) '   ' ...
        'Y: ' vec2str(stSlabImg.DetYPos) ' cm' ];
ht = text(0, 0, string1);
set(ht, 'VerticalAlignment', 'bottom')

string2 = ['n: ' num2str(stSlabImg.idxRefr) ',  ' ...
        'g: ' num2str(stSlabImg.g) ',  ' ...
        '\mu_s: ' num2str(stSlabImg.Mu_s) ' cm^{-1},  ' ...
        '\mu_a: ' num2str(stSlabImg.Mu_a) ' cm^{-1},  ' ...
        'Mod. Freq.: ' vec2str(stSlabImg.ModFreq) ' MHz,   '];

if stSlabImg.SrcSNRflag
    string2 = [string2 'Src. SNR: ' num2str(stSlabImg.SrcSNR) ' dB,  '];
end

if stSlabImg.DetSNRflag
    string2 = [string2 'Det. SNR: ' num2str(stSlabImg.DetSNR) ' dB,  '];
end
        
if stSlabImg.ScatSNRflag
    string2 = [string2 'Scat. Rel. SNR: ' num2str(stSlabImg.ScatSNR) ' dB,  '];
end

string2 = [string2 'Sphere Pos: ' vec2str(stSlabImg.SphereCtr) ' cm,  ' ...
        'radius: ' num2str(stSlabImg.SphereRad) ' cm,  ' ...
        '\delta\mu_a: ' num2str(stSlabImg.SphereDelta) ' cm^{-1}  ' ...
    ];

ht = text(0, 0.02, string2);
set(ht, 'VerticalAlignment', 'bottom')

string3 = ['Boundary: ' stSlabImg.Boundary ',  ' ...
        'Data Source: ' stSlabImg.DataSource ',  ' ...
        'Reconstruction Method: ' stSlabImg.ReconAlg];
switch stSlabImg.ReconAlg
case 'ART'
    string3 = [string3 ': ' int2str(stSlabImg.ARTnIter) ' iterations'];
case 'SIRT'
    string3 = [string3 ': ' int2str(stSlabImg.SIRTnIter) ' iterations'];
case 'TSVD'
    string3 = [string3 ': ' int2str(stSlabImg.TSVDnSV) ' SVs'];
case 'MTSVD'
    string3 = [string3 ': ' int2str(stSlabImg.MTSVDnSV) ' SVs  \lambda: ' ...
            num2str(stSlabImg.MTSVDLambda)];
end

ht = text(0, 0.055, string3);
set(ht, 'VerticalAlignment', 'bottom')

%%
%%  Print date & time in upper right
%%
t = clock;
ht = text(1,1, [int2str(t(4)) ':' int2str(t(5)) '  ' date]);
set(ht, 'VerticalAlignment', 'top');
set(ht, 'HorizontalAlignment', 'right');
