%showVerificationSurf
figure(1)
clf
set(gcf,'DefaultTextInterpreter','none');

nRows = 4;
nCols = 4;
iax = 1;

subplot(nRows, nCols, iax)
pcolor(zTop_initial);
title('zTop_initial')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(zTop_swapped)
title('zTop_swapped')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zTop_swapped, validTop_closeNeighbors))
title('zTop_swapped, validTop_closeNeighbors')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zBottom_swapped, validBottomSwapped_closeNeighbors))
title('zBottom_swapped, validBottomSwapped_closeNeighbors')
colorbar('vert')
iax = iax + 1;

zTopCombined = zTop_swapped;
zTopCombined(logical(validBottomSwapped_closeNeighbors)) = ...
  zBottom_swapped(logical(validBottomSwapped_closeNeighbors));
validBoth_closeNeighbors = ...
  validTop_closeNeighbors | validBottomSwapped_closeNeighbors;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zTopCombined, validBoth_closeNeighbors));
title('zTopCombined, validTop_closeNeighbors')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zTop_swapped, validTop_culled))
title('zTop_swapped, validTop_culled')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zBottom_swapped, validBottomSwapped_culled))
title('zBottom_swapped, validBottomSwapped_culled')
colorbar('vert')
iax = iax + 1;

zTopCombined = zTop_swapped;
zTopCombined(logical(validBottomSwapped_culled)) = ...
  zBottom_swapped(logical(validBottomSwapped_culled));
validBoth_culled = ...
  validTop_culled | validBottomSwapped_culled;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zTopCombined, validBoth_culled));
title('zTopCombined, validBoth_culled')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(reshape(zPredict, size(zTopCombined, 2), size(zTopCombined, 1))');
title('zPredict')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zTop_swapped, validTop_pointCapture))
title('zTop_swapped, validTop_pointCapture')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zBottom_swapped, validBottomSwapped_pointCapture))
title('zBottom_swapped, validBottomSwapped_pointCapture')
colorbar('vert')
iax = iax + 1;

zTopCombined = zTop_swapped;
zTopCombined(logical(validBottomSwapped_pointCapture)) = ...
  zBottom_swapped(logical(validBottomSwapped_pointCapture));
validBoth_pointCapture = ...
  validTop_pointCapture | validBottomSwapped_pointCapture;

subplot(nRows, nCols, iax)
pcolor(infInvalidPixels(zTopCombined, validBoth_pointCapture));
title('zTopCombined, validBoth_pointCapture')
colorbar('vert')
iax = iax + 1;

subplot(nRows, nCols, iax)
pcolor(zTop_final);
title('zTop_final')
colorbar('vert')
iax = iax + 1;
