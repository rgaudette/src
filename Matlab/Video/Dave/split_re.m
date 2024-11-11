function  split_img = split_residual(img);

[ysize,xsize]=size(img);

dum = zeros(ysize,xsize);

count=0;
for i=1:ysize
	for j=1:xsize
            if (img(i,j)<0)
	       dum(i,j) = -1*img(i,j);
               img(i,j) = 0;
               count =count+1;
	    end;
        end;
end;
count

[vq1,comp1] = vq_bit_alloc2(img,6,.001);
[vq2,comp2] = vq_bit_alloc2(dum,6,.001);

ave_comp = (xsize*ysize)/comp1 + (xsize*ysize)/comp2;
ave_comp = (xsize*ysize)/ave_comp;

split_img = vq1 - vq2;
