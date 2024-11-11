function rmdpdwpaths

Path = path;

iDPDWelem = findstr(Path, 'c:\src\matlab\DPDW');
iSemi = findstr(Path, ';');
for ip = iDPDWelem
    iEnd = iSemi - ip;
    iEnd = iSemi(iEnd > 0);
    if isempty(iEnd)
        iEnd = length(Path)+1;
    end
    
    rmpath(Path(ip:min(iEnd)-1))
end
