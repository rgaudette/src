imin=input('input the file name in single quotes. ');
ysize=input('input y dimension of image. ');
xsize=input('input x dimension of image. ');
fid=fopen(imin,'rb');
img_trans=fread(fid,[xsize,ysize],'uchar');
img = img_trans';
fclose(fid);
disp('the input image is ===> img');
image(img);    
colormap(gray(256));
truesize;
       
if (xsize == ysize)
   axis(['square']);
end;
