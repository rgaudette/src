%doVisualize    Display the selected visualization technique.
%
%   Calls: bgyor, mcontour, mslice.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:14 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: doVisualize.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 2.2  1999/02/05 20:33:17  rjg
%  Switched color colrmap to jet.
%
%  Revision 2.1  1998/09/09 15:07:09  rjg
%  Added slice domain handling for mcontour.
%
%  Revision 2.0  1998/08/10 21:41:26  rjg
%  Added the ability to display multiple wavelengths.
%  Updated the structure references to be consistent with V2.
%
%  Revision 1.4  1998/07/30 19:53:17  rjg
%  Change SIdefines codes to strings.
%
%  Revision 1.3  1998/06/10 18:27:09  rjg
%  Flipped grey colormap so that dark indicates a large value, better for
%  printing hardcopys.
%  Added silabel.
%
%  Revision 1.2  1998/06/03 16:35:11  rjg
%  Uses SIdefines codes
%  Figure is now created with default position/size
%
%  Revision 1.1  1998/04/29 15:14:07  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

if exist('siCurrFigure') == 0
    siCurrFigure = 2;
end

ds = getvisinfo(ds);
nLambda = size(ds.xhat, 2);
for i = 1:nLambda
    figure(siCurrFigure)
    clf
    orient landscape

    %%
    %%  Reconstruct image of the volume
    %%
    switch ds.CMap
        case 'grey'
            colormap(flipud(gray(256)));
        case 'bgyor'
            colormap(jet(256));
    end

    switch ds.Visualize
        case 'contour'
            mcontour(ds.xhat(:,i), ds.CompVol, ds.PlaneIndices, ...
                ds.VisPlane, ds.LayoutVector, ds.nCLines);
        case 'image'
            switch ds.CRange
                case 'fixed'
                    mslice(ds.xhat(:,i), ds.CompVol, ds.PlaneIndices, ...
                        ds.VisPlane, ds.LayoutVector, ds.CRangeVal);
                case 'auto'
                    mslice(ds.xhat(:,i), ds.CompVol, ds.PlaneIndices, ...
                        ds.VisPlane, ds.LayoutVector);
            end
    end
    silabel(siCurrFigure);

    siCurrFigure = siCurrFigure + 1;
end

    
set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
