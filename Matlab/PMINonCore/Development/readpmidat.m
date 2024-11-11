%readPMIDat     Read in old PMI data
%
%    pmiStruct = readPMIdat(fname, nDet, nSrc)
%
%    pmiStruct  The MATLAB PMI structure containing the data
%
%    fname      The name of the file containing the old PMI format data.
%
%    nDet       The number of detectors used to generate the data.
%
%    nSrc       The number of sources used to generate the data.
%
%    readPMIDat reads in an old PMI software data file expected to be in ASCII
%    format.  This routine expects the data to be in a 10 column format, writen
%    by the PMI script line
%
%       SaveData file SDposition INC SCATT
%
%    This conversion routine expects all detectors to be measured and all sources
%    to be used with all detectors collected and then the source index
%    incremented.
function pmi = readPMIDat(fname, nDet, nSrc)

%%
%%  Read in the ASCII file
%%
load(fname)
iPeriod = findstr(fname, '.');
if isempty(iPeriod)
    varname = fname;
else
    varname = fname(1:iPeriod-1);
end
eval(['pmidat = ' varname ';']);

%%
%%  Fill in the source and detector positions
%%
if (nDet * nSrc) == size(pmidat, 1)
    pmi.Fwd.Src.Type = 'list';
    pmi.Fwd.Src.Pos = pmidat(1:nDet:nDet*nSrc, 1:3);
    pmi.Fwd.Det.Type = 'list';
    pmi.Fwd.Det.Pos = pmidat(1:nDet, 4:6);

else
    fprintf('Number of source-detector positions %d\n', size(pmidat, 1))
    fprintf('Supplied number of detector positions %d\n', nDet)
    fprintf('Supplied number of source positions %d\n', nSrc)
    warning('Data size mismatch');
end

%%
%%  Fill in the incident response
%%
temp = pmidat(:,7) .* exp(j * pmidat(:,8) * (pi / 180));
pmi.Fwd.PhiInc = [real(temp); imag(temp)];

%%
%%  Fill in the scattered response, the real part for all measurements comes
%%  first and then the imaginary part.  THIS WILL CHANGE SOON FOR VERSION 3.1.
%%
temp = pmidat(:,9) .* exp(j * pmidat(:,10) * (pi / 180));
pmi.Fwd.PhiScat = [real(temp); imag(temp)];

%%
%%  Combine the scattered response and incident response for the total field
%%
pmi.PhiTotal = pmi.Fwd.PhiScat + pmi.Fwd.PhiInc;
