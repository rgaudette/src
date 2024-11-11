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
%  $Date: 2004/01/03 08:26:28 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: silabel.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:28  rickg
%  Matlab Source
%
%  Revision 2.0  1998/08/05 18:20:42  rjg
%  Handles CompVol structure as part of slab image data structure.
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
    stSlabImg = getall;
else
    if isfield(hFigSI, 'CompVol')
        stSlabImg = hFigSI;
    else
        figure(hFigSI);
        stSlabImg = getall;
    end
end


if nargin < 1
    figure(2);
else
    figure(hFigPlot);
end

hax = axes('position', [0 0 1 1]);
set(hax, 'visible', 'off');

string1 = ['X, Y, Z Step: ' num2str(stSlabImg.CompVol.XStep) ', ' ...
        num2str(stSlabImg.CompVol.YStep) ',' ...
        num2str(stSlabImg.CompVol.ZStep) ' cm,  ' ...
        'Source X: ' vec2str(stSlabImg.SrcPos.X) '  ' ...
        'Y: ' vec2str(stSlabImg.SrcPos.Y) '  ' ...
        'Z: ' vec2str(stSlabImg.SrcPos.Z) ' cm,  ' ...
        'Amp.: ' vec2str(stSlabImg.SrcAmp) ' dB,  ' ...
        'Det. X: ' vec2str(stSlabImg.DetPos.X) '   ' ...
        'Y: ' vec2str(stSlabImg.DetPos.Y) '  ' ... 
        'Z: ' vec2str(stSlabImg.DetPos.Z) ' cm'];
ht = text(0, 0, string1);
set(ht, 'VerticalAlignment', 'bottom')

string2 = ['n: ' num2str(stSlabImg.idxRefr) ',  ' ...
        'g: ' num2str(stSlabImg.g) ',  ' ...
        '\mu_s: ' num2str(stSlabImg.Mu_s) ' cm^{-1},  ' ...
        '\mu_a: ' num2str(stSlabImg.Mu_a) ' cm^{-1},  ' ...
        'Mod. Freq.: ' vec2str(stSlabImg.ModFreq) ' MHz,  '];

if stSlabImg.SrcSNRflag
    string2 = [string2 'Src. SNR: ' num2str(stSlabImg.SrcSNR) ' dB,  '];
end

if stSlabImg.DetSNRflag
    string2 = [string2 'Det. SNR: ' num2str(stSlabImg.DetSNR) ' dB,  '];
end
        
if stSlabImg.ScatSNRflag
    string2 = [string2 'Scat. Rel. SNR: ' num2str(stSlabImg.ScatSNR) ' dB,  '];
end

%if isfield(stSlabImg, 'SphereCtr')
%    string2 = [string2 'Sphere Pos: ' vec2str(stSlabImg.SphereCtr) ' cm,  ' ...
%            'radius: ' num2str(stSlabImg.SphereRad) ' cm,  ' ...
%            '\delta\mu_a: ' num2str(stSlabImg.SphereDelta) ' cm^{-1}  ' ...
%            ];
%end


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
case 'TCG'
    string3 = [string3 ': ' int2str(stSlabImg.TCGnIter) ' iterations'];
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
