%%
%%	Create a 32 x 32 image with 4 subblocks
%%
mesa = 5*ones(8);
image = ones(32);
image(4:11,4:11)   = mesa;
image(20:27,4:11)  = mesa;
image(20:27,20:27) = mesa;
image(4:11,20:27)  = mesa;
image1 = image;
image = ones(32);

%%
%%	translate the first block 1 pixel right: my=0 mx = 1
%%
image(4:11,5:12) = mesa;

%%
%%	translate the second block 1 pixel down: my= 1 mx = 0
%%
image(5:12,20:27) = mesa;

%%
%%	translate block three one pixel up and to the left: my= -1 mx =-1
%%
image(19:26,3:10) = mesa;

%%
%%	translate the last block 2 pixels right and 3 down: my = 3 mx= 2
%%
image(23:30,22:29) = mesa;

mesh(image)
image2 =image;

