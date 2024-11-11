%RDSUNRAS       Read a Sun raster file.
%
%   [Image ColorMap] = rdsunras(filename)

function [Image, ColorMap] = rdsunras(filename)

%%
%%  Open the file in binary format for reading.
%%
fid = fopen(filename, 'rb');

%%
%%  Load in the header, note if we are on a PC we need to swap the input
%%  bytes.
%%
c = computer;
if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    ID = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    ID = fread(fid, 1, 'ulong');
end

if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    nRows = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    nRows = fread(fid, 1, 'ulong')
end

if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    nCols = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    nCols = fread(fid, 1, 'ulong')
end

if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    WordSize = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    WordSize =  fread(fid, 1, 'ulong');
end

if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    nBytes = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    nBytes =  fread(fid, 1, 'ulong');
end

if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    Hdr6 = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    Hdr6 =  fread(fid, 1, 'ulong');
end

if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    Hdr7 = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    Hdr7 =  fread(fid, 1, 'ulong');
end

if strcmp(c, 'PCWIN')
    swap = fread(fid, 4, 'uchar');
    Hdr8 = swap(1) * 2^24 + swap(2) * 2^16 + swap(3) * 2^8 + swap(4);
else
    Hdr8 =  fread(fid, 1, 'ulong');
end

%%
%%  Load in the colormap used for the image
%%
ColorMap = fread(fid, [256 3], 'uchar');

%%
%%  Load in the image itself, it needs to be transformed
%%
Image = fread(fid,[nRows nCols], 'uchar');
Image = Image.';
fclose(fid);

