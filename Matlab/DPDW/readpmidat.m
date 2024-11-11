%READPMIDAT     Read in PMI data
%
%    ds = readPMIdat(fname, nDet, nSrc)

function ds = readpmidat(fname, nDet, nSrc)

load(fname)
iPeriod = findstr(fname, '.');
if isempty(iPeriod)
    varname = fname;
else
    varname = fname(1:iPeriod-1);
end
eval(['pmidat = ' varname ';']);

temp = pmidat(:,7) .* exp(j * pmidat(:,8) * (pi / 180));
ds.Fwd.PhiInc = [real(temp); imag(temp)];

temp = pmidat(:,9) .* exp(j * pmidat(:,10) * (pi / 180));
ds.Fwd.PhiScat = [real(temp); imag(temp)];

ds.PhiTotal = ds.Fwd.PhiScat + ds.Fwd.PhiInc;

%%
%%  Make the assumption that the data is in the following format
%%  detectors are cycled through first the y position of the detector is
%%  indexed first amongst detectors, followed by the x and then z.
%%  the same pattern is followed for the sources
%%
if (nDet * nSrc) == size(pmidat, 1)
    ds.Fwd.SrcPos.Type = 'list';
    ds.Fwd.DetPos.Type = 'list';
    ds.Fwd.DetPos.Pos = pmidat(1:nDet, 4:6);
    ds.Fwd.SrcPos.Pos = pmidat(1:nDet:nDet*nSrc, 1:3);
else
    fprintf('Number of source-detector positions %d\n', size(pmidat, 1))
    fprintf('Supplied number of detector positions %d\n', nDet)
    fprintf('Supplied number of source positions %d\n', nSrc)
    warning('Data size mismatch');
end
