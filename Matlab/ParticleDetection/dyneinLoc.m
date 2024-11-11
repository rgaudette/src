%dyneinLoc      Fine tune the location of known dynein particles and average

function [vol] = dyneinLoc(tube, indices, nXY, nZ, nL);

[NXY NZ NL] = size(tube);

% Extract the volume of the kernel object
iKernel = 1;
xyStart = round((NXY - nXY) / 2)
zStart = round((NZ - nZ) / 2)
lStart = round(indices(iKernel) - nL / 2)
kernel = tube(xyStart:xyStart+nXY-1, zStart:zStart+nZ-1, lStart:lStart+nL-1);


% Extract the volume at each index
nSearch = 8;
nXYSearch = nXY + nSearch;
nZSearch = nZ + nSearch;
nLSearch = nL + nSearch;

xySearch = round((NXY - nXYSearch) / 2);
zSearch = round((NZ - nZSearch) / 2);

nDynein = length(indices);
for iDynein = 1:nDynein
  disp(['Processing ' int2str(iDynein)])
  %  Extract the dynein volume
  lSearch = round(indices(iDynein) - nLSearch/2)
  dynein = tube(xySearch:xySearch+nXYSearch-1, ...
                zSearch:zSearch+nZSearch-1, ...
                lSearch:lSearch+nLSearch-1);
  
  %  Compute the cross correlation function and find the indices of the peak
  xcFunc = xcorr3d(dynein, kernel);
  
  % Calculate the max correlation index
  [val idx] = max(xcFunc(:))
  [nR nC nP] = size(xcFunc)
  iRow = mod(idx, nR);
  if iRow == 0
    iRow = nR;
  end

  iCol = mod(ceil(idx/nR), nC);
  if iCol == 0
    iCol = nC;
  end
  
  iPlane = mod(ceil(idx/(nR*nC)), nP);
  if iPlane == 0
    iPlane = nP;
  end
  
  idxDynein = [iRow iCol iPlane]
end
