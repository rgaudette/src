%padXCorr       Calculate the pad cross-correlation coefficient
%
%  peakXCorr = padXCorr(pad1, pad2, nSearch, flgVertical)
%
%  Status: under development

function peakXCorr = padXCorr(pad1, pad2, nSearch, flgVertical)
%%
%%  Flip the second pad to match the orientation of the first
%%
if flgVertical
  pad2 = flipud(pad2);
else
  pad2 = fliplr(pad2);
end

%%
%%  Get the pad sizes and extract the center portion of the second pad
%%
[nRowPad1 nColPad1] = size(pad1);
[nRowPad2 nColPad2] = size(pad2);
xcorrFct = zeros(2*nSearch+1);
pad2Center = pad2(nSearch+1:nRowPad2-nSearch, nSearch+1:nColPad2-nSearch);
[nRowPad2Center nColPad2Center] = size(pad2Center);

pad2CenterNormSq = norm(pad2Center(:))^2;
idxPad1X = [0:nColPad2Center-1];
for iXShift = 1:2*nSearch+1
  idxPad1X = idxPad1X + 1;
  idxPad1Y = [0:nRowPad2Center-1];
  for iYShift = 1:2*nSearch+1
    idxPad1Y = idxPad1Y + 1;
    pad1Shift = pad1(idxPad1Y, idxPad1X);
    xcorrFct(iYShift, iXShift) = sum(sum(pad1Shift .* pad2Center));
  end
end
peakXCorr = max(max(xcorrFct));
peakXCorr = peakXCorr / pad2CenterNormSq;


