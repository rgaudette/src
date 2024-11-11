%figure(1);
%colormap(gray(256));
ysize=256;
xsize=256;

cortez_video;
imin='cortez00';
fid=fopen(imin,'rb');
img=fread(fid,[xsize,ysize],'uchar');
img = img';
fclose(fid);
eval([ imin '=img;']);
eval(['save ' imin ' ' imin]);
%image(img);



%lim=axis;
%movie_handle = moviein(50);
%axis(lim);
%movie_handle(:,1) = getframe;

for i=2:50
    %eval(['imin=',video(i,:),';']);
    imin = video(i,:);

    fid=fopen(imin,'rb');
    img=fread(fid,[xsize,ysize],'uchar');
    img = img';
    fclose(fid);

    eval([ imin '=img;']);
    disp(['save ' imin ' ' imin]);
    eval(['save ' imin ' ' imin]);

    %image(img);

    %movie_handle(:,i) = getframe;
       
end;

