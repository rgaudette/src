%showImage      Display the image specified in the DPDW Imaging structure.
%
%   idxCurrFig = showImage(ds, idxCurrFig)
%
%   ds          The DPDW Imaging data structure containing the
%               reconstruction to be imaged.
%
%   idxCurrFig  OPTIONAL: The number of the figure in which to display the
%               images.  It is also return incremented by the number of
%               figures displayed.  If it is not supplied the current figure
%               is used.
%
%   showImage displays the reconstruction present in the DPDW imaging
%   data structure.
%
%   Calls: getvisinfo, mcontour, mslice.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:31 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: showImage.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:31  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function idxCurrFig = showImage(ds, idxCurrFig)

if nargin < 2
    idxCurrFig = gcf;
end

nLambda = size(ds.Recon.xEst, 2);
for i = 1:nLambda
    figure(idxCurrFig)
    clf
    orient landscape

    %%
    %%  Reconstruct image of the volume
    %%
    switch ds.Visualize.CMap
        case 'grey'
            colormap(flipud(gray(256)));
        case 'bgyor'
            colormap(jet(256));
    end

    switch ds.Visualize.Type
        case 'contour'
            mcontour(ds.Recon.xEst(:,i), ds.Inv.CompVol, ...
                ds.Visualize.PlaneIndices, ds.Visualize.VisPlane, ...
                ds.Visualize.LayoutVector, ds.Visualize.nCLines);
            
        case 'image'
            switch ds.Visualize.CRange
                case 'fixed'
                    mslice(ds.Recon.xEst(:,i), ds.Inv.CompVol, ...
                        ds.Visualize.PlaneIndices, ...
                        ds.Visualize.VisPlane, ...
                        ds.Visualize.LayoutVector, ds.Visualize.CRangeVal);
                    
                case 'auto'
                    mslice(ds.Recon.xEst(:,i), ds.Inv.CompVol, ...
                        ds.Visualize.PlaneIndices, ...
                        ds.Visualize.VisPlane, ds.Visualize.LayoutVector);
            end
    end

%    silabel(idxCurrFig);
    idxCurrFig = idxCurrFig + 1;
end
