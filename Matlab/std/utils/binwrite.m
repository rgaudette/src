%BINWRITE       Write a vector to a binary file.
%
%   binwrite(FileName, Vec, Precision)

function binwrite(FileName, Vec, Precision)

%%
%%  Open the file for writting
%%
[idFile, Msg] = fopen(FileName, 'w');

if(idFile == -1),
    error(Msg);
end

%%
%%  Write out vector
%%
fwrite(idFile, Vec, Precision);

%%
%%  Close file
%%
fclose(idFile);
