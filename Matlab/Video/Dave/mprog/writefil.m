% This function writes a matrix to a binary file   
% Author: David Hoag

imout=input('Output file name in single quote: ');
A=input('Matrix name: ');
A=A';
fid=fopen(imout,'w');
count=fwrite(fid,A,'uchar');
fclose(fid);
count
